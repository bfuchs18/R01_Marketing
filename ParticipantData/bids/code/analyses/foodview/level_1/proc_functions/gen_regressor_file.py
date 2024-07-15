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
fmriprep_dir = "/Users/bari/Library/CloudStorage/OneDrive-ThePennsylvaniaStateUniversity/b-childfoodlab_Shared/Active_Studies/MarketingResilienceRO1_8242020/ParticipantData/bids/derivatives/preprocefmriprep_v2320"
analysis_dir = "/Users/bari/Library/CloudStorage/OneDrive-ThePennsylvaniaStateUniversity/b-childfoodlab_Shared/Active_Studies/MarketingResilienceRO1_8242020/ParticipantData/bids/derivatives/analyses/foodview"
overwrite = True

def gen_regressor_file(sub, fmriprep_dir, analysis_dir, overwrite = False, return_dataframe = False):
    """
    This function will creates a CSV file with nuisance regressors for first-level analyses in AFNI based on fmriprep confound files for a given subject
    The following variables will be included: trans_x, trans_y, trans_z, rot_x, rot_y, rot_z, csf, white_matter, trans_x_derivative1, trans_y_derivative1, trans_z_derivative1, rot_x_derivative1, rot_y_derivative1, rot_z_derivative1

    Inputs:
        sub 
        fmriprep_dir (str) - path to fmriprep/ directory. Confound files will be loaded from bids/derivatives/preprocessed/{fmriprep_path}/sub-{sub}/ses-1/func/
        analysis_dir (str) - path to output directory in bids/derivatives/analyses. Censor files will be exported into bids/derivatives/analyses/{analysis_dir}/level_1/sub-{sub}/
        overwrite (boolean) - specify if output files should be overwritten (default = False)
        return_dataframe (boolean) - specify if nuisance regressors should be returned in a dataframe
    """

    #######################
    ### Check arguments ###
    #######################

    # set sub with leading zeros
    if not sub:
        print("sub is not defined")
        raise Exception()
    else:
        sub = str(sub).zfill(3)
    
    # set fmriprep_dir
    if not fmriprep_dir:

        print("fmriprep_dir must be string")
        raise Exception()

    elif isinstance(fmriprep_dir, str):

        # make input string a path
        fmriprep_dir = Path(fmriprep_dir)

    else: 
        print("bids_dir must be string")
        raise Exception()
    
    # set analysis_dir
    if not analysis_dir:

        print("analysis_dir must be string")
        raise Exception()

    elif isinstance(analysis_dir, str):

        # make input string a path
        analysis_dir = Path(analysis_dir)

    else: 
        print("analysis_dir must be string")
        raise Exception()

    # check overwrite
    if not isinstance(overwrite, bool):
        print("overwrite must be boolean (True or False)")
        raise Exception()

    # check return_dataframe
    if not isinstance(return_dataframe, bool):
        print("return_dataframe must be boolean (True or False)")
        raise Exception()
    
    ##############
    ### Set up ###
    ##############

    # define fmriprep dir
    sub_fmriprep_dir = os.path.join(fmriprep_dir, 'sub-' + str(sub) + '/ses-1/func/')

    # get list of fmriprep confound files
    confound_files = list(Path(sub_fmriprep_dir).rglob('*foodview*confounds_timeseries.tsv'))

    # abort of no events files
    if len(confound_files) < 1:
        print('No foodview confound files found for sub ' + str(sub))
        raise Exception()

    ##################################
    ### Create regressor dataframe ###
    ##################################

    # Make list of nuisance regressors
    nui_regs =['trans_x', 'trans_y', 'trans_z', 'rot_x', 'rot_y', 'rot_z', 'csf', 'white_matter', 'trans_x_derivative1', 'trans_y_derivative1', 'trans_z_derivative1', 'rot_x_derivative1', 'rot_y_derivative1', 'rot_z_derivative1']
    
    # create dataframe to save regressor data to for each run
    all_runs_regressors_data = pd.DataFrame(np.zeros((0, len(nui_regs))))
    all_runs_regressors_data.columns = nui_regs

    confound_files.sort()
    for file in confound_files: #loop through runs (each run has its own confoundfile)

        #load data
        confound_data = pd.read_csv(str(file), sep = '\t', encoding = 'ascii', engine='python')

        # add run-specific regressor data to overall regressor file
        run_regressors_data = confound_data[nui_regs].copy()
        all_runs_regressors_data = pd.concat([all_runs_regressors_data, run_regressors_data])

    # for first row [0] of motion derivative variables in regress_Pardat, replace NA with 0. This will allow deriv variables to be entered into AFNI's 3ddeconvolve
    deriv_vars = ['trans_x_derivative1', 'trans_y_derivative1', 'trans_z_derivative1', 'rot_x_derivative1', 'rot_y_derivative1', 'rot_z_derivative1']
    all_runs_regressors_data.loc[0, deriv_vars] = all_runs_regressors_data.loc[0, deriv_vars].fillna(value=0)

    ##############################
    ### Export regressor files ###
    ##############################

    # define subject export dir
    sub_analysis_dir = os.path.join(analysis_dir, 'level_1/sub-' + str(sub) + '/')

    # Make directory for export 
    Path(sub_analysis_dir).mkdir(parents=True, exist_ok=True)
    
    # define output file path
    filepath = Path(sub_analysis_dir).joinpath('sub-' + sub + '_nuisance_regressors.tsv')

    # issue message if the file already exists and overwrite is False, otherwise export
    if filepath.exists() and not overwrite:
        print('Nuisance regressor file already exist for sub-' + str(sub) + '. Use overwrite = True to overwrite')
    else:
        all_runs_regressors_data.to_csv(str(filepath), sep = '\t', encoding='ascii', index = False, header=True)

    # return dataframe
    if return_dataframe is True:
        return(all_runs_regressors_data)