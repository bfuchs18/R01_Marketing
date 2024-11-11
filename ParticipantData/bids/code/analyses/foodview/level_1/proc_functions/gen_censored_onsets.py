#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
This function will:
(1) determine the number of TRs censored in each run overall and for image blocks, export this information for a subject in a TSV
(2) export onset files with runs censored based on a given criteria (1 per trial_type)

This function requires that the following exist in derivatives/analyses/foodview/level_1/sub-{label}/:
- generated 1D files (gen_censor_files) with censor info
- uncensored onsets?? (gen_uncensored_onsets)

@author: baf44
"""

#set up packages    
import pandas as pd
import os
from pathlib import Path

def gen_censored_onsets(sub, uncensored_onsets_dict, censor_summary_dataframe, p_uncensored_trs_thresh = False, p_uncensored_image_trs_thresh = False, fd_thresh = .9, overwrite = False, analysis_dir = False):
    """
    This function will generated censored onset files and censor summaries based metrics on censor_summary_dataframe

    Inputs:
        sub 
        uncensored_onsets_dict: dictionary returned by gen_uncensored_onsets())
        censor_summary_dataframe: dataframe returned by gen_censor_summary()
        p_uncensored_trs_thresh (optional*): float -- a run will be censored if censor_summary_dataframe['p_uncensored_trs'] is below threshold
        p_uncensored_image_trs_thresh (optional*): float -- a run will be censored if censor_summary_dataframe['p_uncensored_image_trs'] is below threshold
        fd_thresh (int or float) - threshold use to censor TRs in gen_censor_files() -- this will be used to name the output files
        analysis_dir (str) - path to output directory in bids/derivatives/analyses
        overwrite (boolean) - specify if output file should be overwritten (default = False)

        * either p_uncensored_trs_thresh or p_uncensored_image_trs_thresh is required

    Exports:
        censored onset files (1 per trial_type); exported into bids/derivatives/analyses/{analysis_dir}/level_1/sub-{sub}/onsets_censored_[censor_string]
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
    
    # check uncensored_onsets_dict
    if not isinstance(uncensored_onsets_dict, dict):
        raise TypeError("uncensored_onsets_dict must be a dictionary")
    
    # check censor_summary_dataframe
    if not isinstance(censor_summary_dataframe, pd.DataFrame):
        raise TypeError("censor_summary_dataframe must be pandas dataframe")

    # check p_uncensored_trs_thresh and p_uncensored_image_trs_thresh
    if p_uncensored_trs_thresh or p_uncensored_image_trs_thresh:
        if p_uncensored_trs_thresh:
            # check value is float
            if not isinstance(p_uncensored_trs_thresh, float):
                raise TypeError("p_uncensored_trs_thresh must be float (e.g., p_uncensored_trs_thresh = .8)")
        if p_uncensored_image_trs_thresh:
            # check value is float
            if not isinstance(p_uncensored_image_trs_thresh, float):
                raise TypeError("p_uncensored_image_trs_thresh must be float (e.g., p_uncensored_image_trs_thresh = .8)")
    else: 
        raise Exception("p_uncensored_trs_thresh or p_uncensored_image_trs_thresh but be provided")


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
        raise TypeError("rmsd must be integer or float")
    
    ###############################
    ### Determine censored runs ###
    ###############################

    run_censor_dict = {}

    for run in censor_summary_dataframe['run'].to_list():
        
        #set default to 1, indicating run is not censored
        censor_val = 1

        if p_uncensored_trs_thresh:

            if float(censor_summary_dataframe.loc[censor_summary_dataframe['run'] == run, 'p_uncensored_trs'].values[0]) < p_uncensored_trs_thresh:
                print(f"censor {run} based on p_uncensored_trs_thresh")
                censor_val = 0 # indicate run should be censored

        if p_uncensored_image_trs_thresh:

            if float(censor_summary_dataframe.loc[censor_summary_dataframe['run'] == run, 'p_uncensored_image_trs'].values[0]) < p_uncensored_image_trs_thresh:
                print(f"censor {run} based on p_uncensored_image_trs_thresh")
                
                censor_val = 0 # indicate run should be censored
                
        run_censor_dict[run] = censor_val


    ########################################
    ### Modify onsets based on censoring ###
    ########################################

    censored_onsets_dict = uncensored_onsets_dict.copy()

    for trial_type in censored_onsets_dict.keys():

        for run in censored_onsets_dict[trial_type].keys():

            # if run should be censored
            if run_censor_dict[run] == 0:
                
                # make onsets an empty list
                censored_onsets_dict[trial_type][run] = []

    ##############
    ### Export ###
    ##############

    # define subject uncensored onset directory
    if p_uncensored_trs_thresh:
        r_censor_string = "_tot-thresh-" + str(p_uncensored_trs_thresh)
    else: 
        r_censor_string = ""

    if p_uncensored_image_trs_thresh:
        image_censor_string = "_image-thresh-" + str(p_uncensored_image_trs_thresh)
    else: 
        image_censor_string = ""

    censor_str = 'fd-' + str(fd_thresh) + r_censor_string + image_censor_string


    sub_onset_dir = os.path.join(analysis_dir, 'level_1', 'sub-' + str(sub), 'onsets_censored_' + censor_str)
    Path(sub_onset_dir).mkdir(parents=True, exist_ok=True)

    # export onset files
    for trial_type_key in censored_onsets_dict:
        
        # define path to outfuile
        out_file_path = Path(sub_onset_dir).joinpath('sub-' + sub + '_' + trial_type_key + '_onsets.txt')
        
        if not out_file_path.exists() or overwrite:

            print(f"Exporting {trial_type_key} censored onset file for sub {str(sub)}")
            
            # get array of runs in ascending order
            runnum_keys_sorted = sorted(censored_onsets_dict[trial_type_key].keys()) 

            # open a text file for writing
            with open(out_file_path, 'w') as file:

                # for each run
                for run in runnum_keys_sorted:

                    # extract onset values
                    onset_values = censored_onsets_dict[trial_type_key][run]

                    # row is '* *' if no onset values, otherwise it is tab separated onsets
                    ## add asterick at the end of each row, because 1 column format is interpreted by AFNI as global times
                    if not onset_values:
                        row = "*\t*"
                    else: 
                        row = '\t'.join(str(x) for x in onset_values)  + '\t*'

                    # write row to file
                    file.write(row + '\n')

        else:
            print(f"{trial_type_key} censored onset files already exist for sub {str(sub)}. Use overwrite = True to overwrite")
            
    return  ()
