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

def gen_censor_summary(sub, uncensored_onsets_dict, censordata_dict, analysis_dir, fd_thresh = .9, overwrite = False, return_summary_dataframe = False):
    """
    This function will use censor data (output from gen_censor_files) and onset data (output from gen_uncensored_onsets) to quantify by run:
        (1) the total number of TRs
        (2) the total number and (3) percent of censored TRs
        (4) the number of image block TRs
        (5) the number and (6) percent of censored image block TRs
        (7) the number of commerical block TRs
        (8) the number and (9) percentage of censored commerical block TRs

    Inputs:
        sub 
        uncensored_onsets_dict: dictionary returned by gen_uncensored_onsets())
        censordata_dict: dictionary returned by gen_censor_files())
        fd_thresh (int or float) - threshold use to censor TRs in gen_censor_files() -- this will be used to name the output file
        analysis_dir (str) - path to output directory in bids/derivatives/analyses
        overwrite (boolean) - specify if output file should be overwritten (default = False)
        return_summary_dataframe (boolean) - specify if summary_dataframe should be returned

    
    Exports: TSV with summary metrics for given subject (1 row per run); exported into bids/derivatives/analyses/{analysis_dir}/level_1/sub-{sub}/

    Outputs: if return_summary_dataframe = True, returns summary_dataframe -- a long dataframe of summary metrics for given subject (1 row per run)

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
    
    ##########################################################################
    ### Make commerical and image block TR onset dicts (across conditions) ###
    ##########################################################################
    
    TR = 2

    # initialize dict to store commerical block
    commerical_block_onset_dict = {}

    for run in uncensored_onsets_dict['ad_food']:
        # combine commercial onsets
        commerical_block_onset_dict[run] = uncensored_onsets_dict['ad_food'][run] + uncensored_onsets_dict['ad_toy'][run]

        # divide all onsets (originally in seconds) by TR and round to nearest integer
        commerical_block_onset_dict[run] = [round(onset / 2) for onset in commerical_block_onset_dict[run]]

    # initialize dict to store image block onsets
    image_block_onsets_dict = {}
    for run in uncensored_onsets_dict['ad_food']:
        # combine all image block categories into 1 dictionary
        image_block_onsets_dict[run] = uncensored_onsets_dict['hed_savory_toy_cond'][run] + uncensored_onsets_dict['hed_savory_food_cond'][run] + uncensored_onsets_dict['led_savory_toy_cond'][run] + uncensored_onsets_dict['led_savory_food_cond'][run] + uncensored_onsets_dict['hed_sweet_toy_cond'][run] + uncensored_onsets_dict['hed_sweet_food_cond'][run] + uncensored_onsets_dict['led_sweet_toy_cond'][run] + uncensored_onsets_dict['led_sweet_food_cond'][run]
        
        # divide all onsets (originally in seconds) by TR and round to nearest integer
        image_block_onsets_dict[run] = [round(onset / 2) for onset in image_block_onsets_dict[run]]

    #######################################
    ### Create censor summary dataframe ###
    #######################################

    # get list of runs based on keys in censordata_dict
    runs = [key for key in censordata_dict.keys() if key.startswith('run-')]

    # define block lengths (in TRs)
    image_block_length = 5
    commercial_bloock_length = 15

    summary_dict = {}
    for run in runs:

        # extract censordata
        run_censor_data = censordata_dict[run]

        # make list of 0s the length of run_censor_data
        run_trial_list = [0] * len(run_censor_data)

        # replace values in run_trial_list with 1 for image block TRs
        for onset in image_block_onsets_dict[run]: #loop through onsets
            offset = onset + image_block_length  #Get block offset -- note: this will be the first TR after the block of interest
            run_trial_list[onset:offset] = [1] * image_block_length  #At indices onset to offset-1 in run_trial_list, set value to 1

        # replace values in run_trial_list with 2 for commerical block TRs
        for onset in commerical_block_onset_dict[run]: #loop through onsets
            offset = onset + commercial_bloock_length  #Get block offset -- note: this will be the first TR after the block of interest
            run_trial_list[onset:offset] = [2] * commercial_bloock_length  #At indices onset to offset-1 in run_trial_list, set value to 1

        # combine TR type and censor data into dataframe
        run_data = pd.DataFrame({'tr_censor': run_censor_data, 'tr_type': run_trial_list})

        # use tr_type_list and run_censor_data to get the following summary information
        n_trs = len(run_data)
        n_image_trs = sum(run_data['tr_type'] == 1)
        n_commerical_trs = sum(run_data['tr_type'] == 2)

        n_uncensored = sum(run_data['tr_censor'] == 1)
        n_uncensored_image = len(run_data[(run_data['tr_censor'] == 1) & (run_data['tr_type'] == 1)])
        n_uncensored_commerical = len(run_data[(run_data['tr_censor'] == 1) & (run_data['tr_type'] == 2)])

        p_uncensored = n_uncensored/n_trs
        p_uncensored_image = n_uncensored_image/n_image_trs
        p_uncensored_commerical = n_uncensored_commerical/n_commerical_trs

        # save to dictionary
        summary_dict[run] = {
            'n_trs' : n_trs,
            'n_image_trs' : n_image_trs,
            'n_commerical_trs' : n_commerical_trs,
            'n_uncensored_trs' : n_uncensored,
            'n_uncensored_image_trs' : n_uncensored_image,
            'n_uncensored_commerical_trs' : n_uncensored_commerical,
            'p_uncensored_trs' : p_uncensored,
            'p_uncensored_image_trs' : p_uncensored_image,
            'p_uncensored_commerical_trs' : p_uncensored_commerical
        }

    # convert dictionary to dataframe
    summary_dataframe = pd.DataFrame.from_dict(summary_dict, orient='index').reset_index()
    summary_dataframe.rename(columns={'index': 'run'}, inplace=True)
    summary_dataframe['sub'] = sub # add subject column
    summary_dataframe['fd_thresh'] = fd_thresh # add subject column

    # reorder so subject column is first
    cols = ['sub', 'run', 'fd_thresh'] + pd.DataFrame.from_dict(summary_dict, orient='index').columns.tolist()
    summary_dataframe = summary_dataframe[cols]

    ##############
    ### Export ###
    ##############

    # define subject analysis
    sub_analysis_dir = os.path.join(analysis_dir, 'level_1/sub-' + str(sub))

    # set censor string 
    censor_str = "fd-" + str(fd_thresh)

    # define output file name
    file_name = Path(os.path.join(sub_analysis_dir, 'sub-' + sub + '_ses-1_task-foodview_censor-summary_' + str(censor_str) + '.tsv'))

    if not file_name.exists() or overwrite:
        print(f"Exporting censor summary for sub {str(sub)}")
        summary_dataframe.to_csv(str(file_name), sep = '\t', encoding='utf-8-sig', index = False)

    if return_summary_dataframe:
        return (summary_dataframe)
