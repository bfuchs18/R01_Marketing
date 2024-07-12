#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
This function creates a CSV file with nuisance regressors for first-level analyses in AFNI based on fmriprep confound files

The following variables will be included: trans_x, trans_y, trans_z, rot_x, rot_y, rot_z, csf, white_matter, trans_x_derivative1, trans_y_derivative1, trans_z_derivative1, rot_x_derivative1, rot_y_derivative1, rot_z_derivative1

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
bids_dir = "/Users/bari/Library/CloudStorage/OneDrive-ThePennsylvaniaStateUniversity/b-childfoodlab_Shared/Active_Studies/MarketingResilienceRO1_8242020/ParticipantData/bids"
overwrite = True

def gen_regressor_file(sub, bids_dir, overwrite = False, return_dataframe = False):

    #######################
    ### Check arguments ###
    #######################

    # set sub with leading zeros
    if not sub:
        print("sub is not defined")
        raise Exception()
    else:
        sub = str(sub).zfill(3)
    
    # set bids_dir
    if not bids_dir:

        print("bids_dir must be string")
        raise Exception()

    elif isinstance(bids_dir, str):

        # make input string a path
        bids_dir = Path(bids_dir)

    else: 
        print("bids_dir must be string")
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
    fmriprep_dir = os.path.join(bids_dir, 'derivatives/preprocessed/fmriprep_v2320/sub-' + str(sub) + '/ses-1/func/')

    # get list of fmriprep confound files
    confound_files = list(Path(fmriprep_dir).rglob('*foodview*confounds_timeseries.tsv'))

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

    # define output directory
    out_dir = os.path.join(bids_dir, 'derivatives/analyses/foodview/level_1/sub-' + str(sub) + '/')

    # make output directory if it doesnt exist
    os.makedirs(out_dir, exist_ok=True)

    # define output file path
    output_path = Path(out_dir).joinpath('sub-' + sub + '_nuisance_regressors.tsv')

    # issue message if the file already exists and overwrite is False, otherwise export
    if output_path.exists() & (overwrite is False):
        print('Nuisance regressor file already exist for sub-' + str(sub) + ' ... Use overwrite = True to overwrite')
    else:
        run_regressors_data.to_csv(str(output_path), sep = '\t', encoding='ascii', index = False, header=False)

    # return dataframe
    if return_dataframe is True:
        return(run_regressors_data)