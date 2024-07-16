#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
@author: baf44
"""

#set up packages    
import numpy as np
import pandas as pd
import os
from pathlib import Path

#########################################################
####                  Subfunctions                   ####
#########################################################


def _gen_run_censorfile(confound_dat, fd_thresh):
    """Function to determine what TRs (i.e., volumes) need to be censored based on given criteria

    TR censor criteria:
    (1) First or second TR (datapoints 0 and 1)
    (2) fd > fd_thresh
    (3) TR was detected by fmriprep as a steady state outlier
    
    Inputs:
        confound_dat (dataframe) - data from a -desc-confounds_timeseries.tsv (fmriprep output)
        fd_thresh (float) - framewise displacement threshold
    Outputs:
        run_censordata (list) - length equal to number of TRs in input dataset; 
            0 = TR is to be censored, 1 = TR is to be included in analyses
    """

    confound_dat = confound_dat.reset_index()  # make sure indexes pair with number of rows

    run_censordata = []

    # Create a boolean mask for each condition
    mask1 = np.arange(len(confound_dat)) < 2
    mask2 = confound_dat['framewise_displacement'] > fd_thresh
    mask3 = confound_dat['non_steady_state_outlier00'] == 1

    # Combine masks using the logical OR operation -- the resulting mask will have the value True wherever at least one of the individual masks has the value True.
    combined_mask = mask1 | mask2 | mask3

    # Use the combined mask to create the run_censordata list -- the ~ (tilde) operator will negate the mask (True becomes False, vice versa)
    run_censordata = (~combined_mask).astype(int).tolist()

    return(run_censordata)


##############################################################################
####                                                                      ####
####                             Main Function                            ####
####                                                                      ####
##############################################################################

# for debugging
fmriprep_dir = "/Users/bari/Library/CloudStorage/OneDrive-ThePennsylvaniaStateUniversity/b-childfoodlab_Shared/Active_Studies/MarketingResilienceRO1_8242020/ParticipantData/bids/derivatives/preprocessed/fmriprep_v2320"
analysis_dir = "/Users/bari/Library/CloudStorage/OneDrive-ThePennsylvaniaStateUniversity/b-childfoodlab_Shared/Active_Studies/MarketingResilienceRO1_8242020/ParticipantData/bids/derivatives/analyses/foodview"

def gen_censor_files(sub, fmriprep_dir, analysis_dir, fd_thresh=0.9, overwrite = False, return_censordata_dict = False):
    """
    This function will generate 1D censor files from -desc-confounds_timeseries.tsv files (output from fmriprep) for given subject. 
    Censor files contain 0 for censored TRs and 1 for uncensored TRs. TRs will be censored if they (1) are the first or seconds TR in a run, (2) have a framewise displacement > fd_thresh, or (3) are steady state outliers

    Inputs:
        sub 
        fd_thresh (int or float): threshold for framewise displacement. Default set to .9 to match ABCD criteria.
        fmriprep_dir (str) - path to fmriprep/ directory. Confound files will be loaded from bids/derivatives/preprocessed/{fmriprep_path}/sub-{sub}/ses-1/func/
        analysis_dir (str) - path to output directory in bids/derivatives/analyses. Censor files will be exported into bids/derivatives/analyses/{analysis_dir}/level_1/sub-{sub}/
        overwrite (boolean) - specify if output files should be overwritten (default = False)
    
    Output:
        if return_censordata_dict = True, function will return a dictionary with keys for each run (e.g., 'run-01') and 'all-runs' with key-value lists of 1s and 0s indicating TR censor status

    Exports:
        1D files for each run and all runs combined

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
   
    # check fd_thresh input
    if isinstance(fd_thresh, int) or isinstance(fd_thresh, float):
            fd_thresh = float(fd_thresh)
    else:
        raise TypeError("fd_thresh must be integer or float")
    
    # check return_censordata_dict
    if not isinstance(return_censordata_dict, bool):
        raise TypeError("return_censordata_dict must be boolean (True or False)")
    
    ##############
    ### Set up ###
    ##############

    # define subject fmriprep dir
    sub_fmriprep_dir = os.path.join(fmriprep_dir, 'sub-' + str(sub) + '/ses-1/func/')

    # get list of fmriprep confound files
    confound_files = list(Path(sub_fmriprep_dir).rglob('*foodview*confounds_timeseries.tsv'))

    # abort of no events files
    if len(confound_files) < 1:
        print('No foodview confound files found for sub ' + str(sub))
        raise Exception()

    ###########################
    ### Create censor files ###
    ###########################

    # create dictionary to store run censor data in
    censordata_dict = {'all-runs': []}

    # sort files so that when run censor data is added to censordata_dict['all_runs'] it is added in run order
    confound_files.sort()

    for file in confound_files:

        # get file name
        file_name = file.name

        # get run (e.g., 'run-01')
        run = file_name.split('_')[3]

        #load data
        confound_data = pd.read_csv(str(file), sep = '\t', encoding = 'utf-8-sig', engine='python')

        # add non-steady-state outlier column (only exists in confound.tsv files with non-steady-state outliers)
        if 'non_steady_state_outlier00' not in confound_data:
            confound_data['non_steady_state_outlier00'] = 0

        # run function to generate run censor data
        run_censordata = _gen_run_censorfile(confound_data, fd_thresh)
        
        # add run_censordata to dictionary in new key-value pair
        censordata_dict[run] = run_censordata

        # extend censordata_dict['all_runs'] with run_censordata
        censordata_dict['all-runs'].extend(run_censordata)

    # define subject export dir
    sub_analysis_dir = os.path.join(analysis_dir, 'level_1/sub-' + str(sub))

    # Make directory for export 
    Path(sub_analysis_dir).mkdir(parents=True, exist_ok=True)
    
    # set censor string 
    censor_str = "fd-" + str(fd_thresh)

    for key in censordata_dict:

        # define output file name
        file_name = Path(os.path.join(sub_analysis_dir, 'sub-' + sub + "_ses-1_task-foodview_" + key + '_censor_' + str(censor_str) + '.1D'))

        # check if output file already exists 
        if not file_name.exists() or overwrite:
            print('Exporting ' + key + ' censor file for sub ' + str(sub))

            # Open the file in write mode
            with open(file_name, 'w') as file:
                for item in censordata_dict[key]:
                    file.write(f"{item}\n") #write each censor value to a new line
            
        else:
            print(key + ' censor file already exist for sub ' + str(sub) + '. Use overwrite = True to overwrite')

    # return particpant databases with censor info
    if return_censordata_dict:
        return censordata_dict