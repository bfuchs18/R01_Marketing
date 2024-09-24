#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
@author: baf44
"""

#set up packages    
from pickle import TRUE
import pandas as pd
import numpy as np
import os
from pathlib import Path

##############################################################################
####                                                                      ####
####                             Core function                            ####
####                                                                      ####
##############################################################################

# for debugging
sub = 1
fmriprep_dir = "/Users/baf44/projects/Keller_Marketing/ParticipantData/bids/derivatives/preprocessed/fmriprep_v2320"
analysis_dir = "/Users/baf44/projects/Keller_Marketing/ParticipantData/bids/derivatives/analyses/sst"
overwrite = True

def gen_sst_regressor_file(sub, fmriprep_dir, analysis_dir, overwrite = False, return_regressordata_dict = False):
    """
    This function exports 
    (1) a CSV file with nuisance regressors for first-level analyses in AFNI based on fmriprep confound files for a given subject
    (2) a TSV file with average framewise displacement, for inclusion as a group-level covariate

    The following variables are nuisance regressors: trans_x, trans_y, trans_z, rot_x, rot_y, rot_z, csf, white_matter, trans_x_derivative1, trans_y_derivative1, trans_z_derivative1, rot_x_derivative1, rot_y_derivative1, rot_z_derivative1

    Inputs:
        sub 
        fmriprep_dir (str) - path to fmriprep/ directory. Confound files will be loaded from bids/derivatives/preprocessed/{fmriprep_path}/sub-{sub}/ses-1/func/
        analysis_dir (str) - path to output directory in bids/derivatives/analyses. Censor files will be exported into bids/derivatives/analyses/{analysis_dir}/level_1/sub-{sub}/
        overwrite (boolean) - specify if output files should be overwritten (default = False)
        return_regressordata_dict (boolean) - specify if nuisance regressor dataframes should be returned in a dictionary (keys per run and overall)
    """

    #######################
    ### Check arguments ###
    #######################

    # check sub
    try:
        sub_int = int(sub)  # Attempt to convert sub to an integer
        sub = str(sub).zfill(3) # define sub as string with 3 leading zeros
    except (ValueError, TypeError):
        raise ValueError("The required argument 'sub' must be a integer (e.g., 1) or a value that can be converted to an integer (e.g., '001')")
    
    # set fmriprep_dir
    if isinstance(fmriprep_dir, str):
        # make input string a path
        fmriprep_dir = Path(fmriprep_dir)
    else: 
        raise TypeError("bids_dir must be string")
    
    # set analysis_dir
    if isinstance(analysis_dir, str):
        # make input string a path
        analysis_dir = Path(analysis_dir)
    else: 
        raise TypeError("analysis_dir must be string")

    # check overwrite
    if not isinstance(overwrite, bool):
        raise TypeError("overwrite must be boolean (True or False)")

    # check return_dataframe
    if not isinstance(return_regressordata_dict, bool):
        raise TypeError("return_regressordata_dict must be boolean (True or False)")
    
    ##############
    ### Set up ###
    ##############

    # define fmriprep dir
    sub_fmriprep_dir = os.path.join(fmriprep_dir, 'sub-' + str(sub) + '/ses-1/func/')

    # get list of fmriprep confound files
    confound_files = list(Path(sub_fmriprep_dir).rglob('*sst*confounds_timeseries.tsv'))

    # abort of no events files
    if len(confound_files) < 1:
        print('No sst confound files found for sub ' + str(sub))
        raise Exception()

    #########################################
    ### Extract data from fmriprep output ###
    #########################################

    # Make list of nuisance regressors
    nui_regs =['trans_x', 'trans_y', 'trans_z', 'rot_x', 'rot_y', 'rot_z', 'csf', 'white_matter', 'trans_x_derivative1', 'trans_y_derivative1', 'trans_z_derivative1', 'rot_x_derivative1', 'rot_y_derivative1', 'rot_z_derivative1']
    
    # create dictionaries to store data in
    regressor_data_dict = {'all-runs': []} # for each run, dataframe will be appended to 'all-runs' list, and added in their own key-value pair
    fd_dict = {'all-runs': []} # for each run, list will be merged with 'all-runs' list, and added in their own key-value pair

    confound_files.sort()
    for file in confound_files: #loop through runs (each run has its own confoundfile)

        # get file name
        file_name = file.name

        # get run (e.g., 'run-01')
        run = file_name.split('_')[3]

        #load data
        confound_data = pd.read_csv(str(file), sep = '\t', encoding = 'ascii', engine='python')

        # subset regressor data for run
        run_regressors_data = confound_data[nui_regs].copy()

        # for first row [0] of motion derivative variables in run_regressors_data, replace NA with 0. This will allow deriv variables to be entered into AFNI's 3ddeconvolve
        deriv_vars = ['trans_x_derivative1', 'trans_y_derivative1', 'trans_z_derivative1', 'rot_x_derivative1', 'rot_y_derivative1', 'rot_z_derivative1']
        run_regressors_data.loc[0, deriv_vars] = run_regressors_data.loc[0, deriv_vars].fillna(value=0)

        # add run-specific regressor data to dictionary in new key-value pair
        regressor_data_dict[run] = run_regressors_data

        # extend regressor_data_dict['all_runs'] with regressor_data_dict
        regressor_data_dict['all-runs'].append(run_regressors_data)

        # add framewise_displacement to fd_dict for run and 'all_runs'
        fd_dict[run] = confound_data['framewise_displacement'].to_list()
        fd_dict["all-runs"] = fd_dict["all-runs"] + fd_dict[run]

    # Concatenate the dataframes in 'all-runs' list into 1 dataframe
    regressor_data_dict['all-runs'] = pd.concat(regressor_data_dict['all-runs'], ignore_index=True)

    # Compute average fd for each key
    avg_fd_dict = {key: [np.nanmean(value)] for key, value in fd_dict.items()}
    avg_fd_df = pd.DataFrame.from_dict(avg_fd_dict)
    avg_fd_df['participant_id'] = 'sub-' + str(sub)

    ####################
    ### Export files ###
    ####################

    # define subject export dir
    sub_analysis_dir = os.path.join(analysis_dir, 'level_1/sub-' + str(sub) + '/')

    # Make directory for export 
    Path(sub_analysis_dir).mkdir(parents=True, exist_ok=True)
    
    # Export regressor file per run and overall
    for key in regressor_data_dict:

        # define output file name
        file_name = Path(os.path.join(sub_analysis_dir, 'sub-' + sub + "_ses-1_task-sst_" + key + '_nuisance-regressors.tsv'))

        # if file doesnt exist or overwrite is True
        if not file_name.exists() or overwrite:
            print('Exporting ' + key + ' regressor file for sub ' + str(sub))
            regressor_data_dict[key].to_csv(str(file_name), sep = '\t', encoding='ascii', index = False, header=False)

        else:
            print(key + ' regressor file already exist for sub ' + str(sub) + '. Use overwrite = True to overwrite')

    # Export 1 file with average displacement values 
    fd_file_name = Path(os.path.join(sub_analysis_dir, 'sub-' + sub + '_ses-1_task-sst_avg-fd.tsv'))

    if not fd_file_name.exists() or overwrite:
        print('Exporting average framewise displacement file for sub ' + str(sub))
        avg_fd_df.to_csv(fd_file_name, index=False, sep ='\t') 

    # return dictionary
    if return_regressordata_dict is True:
        return(regressor_data_dict)