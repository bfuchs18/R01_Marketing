#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
This function creates uncensored onset files (AFNI format) for the food view task.
One onset file is generated for each of the following trial types: food commercial block (food_ad), toy commercial block (toy_ad), high-ED savory food image block after toy commercial (hed_savory_toy_cond), high-ED savory food image block after food commercial (hed_savory_food_cond), high-ED sweet food image block after toy commercial (hed_sweet_toy_cond), high-ED sweet food image block after food commercial (hed_sweet_food_cond), low-ED savory food image block after toy commercial (led_savory_toy_cond), low-ED savory food image block after food commercial (led_savory_food_cond), low-ED sweet food image block after toy commercial (led_sweet_toy_cond), low-ED sweet food image block after food commercial (led_sweet_food_cond)

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

def gen_uncensored_onsets(sub, bids_dir, overwrite = False, return_onset_df = False):

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

    # check return_onset_df
    if not isinstance(return_onset_df, bool):
        print("return_onset_df must be boolean (True or False)")
        raise Exception()
    
    ##############
    ### Set up ###
    ##############

    # define output directory
    out_dir = os.path.join(bids_dir, 'derivatives/analyses/foodview/level_1/sub-' + str(sub) + '/onsets_uncensored')

    # make output directory if it doesnt exist
    os.makedirs(out_dir, exist_ok=True)

    # get list of events files
    events_files = list(Path(bids_dir).rglob('sub-' + str(sub) + '/ses-1/func/*foodview*events.tsv'))

    # abort of no events files
    if len(events_files) < 1:
        print('No *events.tsv files found for sub ' + str(sub))
        raise Exception()

    # get list of existing onset files 
    onset_files = list(Path(out_dir).rglob('*.txt'))

    # exit if onset files exist and overwrite is False
    if len(onset_files) > 0 & overwrite is False:
        print('Uncensored onset files already exist for' + str(sub) + ' ... Use overwrite = True to overwrite')
        raise Exception()

    ##########################################
    ### Extract onset times for each block ###
    ##########################################

    # get number of runs
    n_runs = len(events_files)

    # initialize nested dictionary with 1 dictionary per condition (key = run number, value = [])
    onsets_dict = {
    'ad_food': {i: [] for i in range(1, n_runs + 1)},
    'ad_toy': {i: [] for i in range(1, n_runs + 1)},
    'hed_savory_toy_cond': {i: [] for i in range(1, n_runs + 1)},
    'hed_savory_food_cond': {i: [] for i in range(1, n_runs + 1)},
    'led_savory_toy_cond': {i: [] for i in range(1, n_runs + 1)},
    'led_savory_food_cond': {i: [] for i in range(1, n_runs + 1)},
    'hed_sweet_toy_cond': {i: [] for i in range(1, n_runs + 1)},
    'hed_sweet_food_cond': {i: [] for i in range(1, n_runs + 1)},
    'led_sweet_toy_cond': {i: [] for i in range(1, n_runs + 1)},
    'led_sweet_food_cond': {i: [] for i in range(1, n_runs + 1)},
    }

    # loop though eventsfiles
    for file_path in events_files:

        # extract file basename
        file_name = file_path.name

        # extract run number from file name
        run = file_name.split("_")[3]
        run_num = int(run[4:])

        #load data
        events_dat = pd.read_csv(str(file_path), sep = '\t', encoding = 'utf-8-sig', engine='python')

        #extract video rows
        video_rows = events_dat[events_dat['stim_file'].str.contains('mp4')].copy()

        # add block column that contains the block identifer from stimulus file name (e.g., setA_blockB_toy2.mp4 yields "B")
        video_rows['block'] = video_rows['stim_file'].str.split('_').str[1].str[-1]

        # get number of video events -- will be zero if child aborted scan before any vid blocks finished
        n_vid_events = len(video_rows)

        # get video block onsets if there are video events
        if n_vid_events > 0:
            
            # extract onsets by ad condition and block
            for ad_cond in ["toy", "food"]:

                ad_cond_rows = video_rows[video_rows['stim_file'].str.contains(ad_cond)].copy()

                for block in ad_cond_rows['block'].unique():
                    
                    block_cond_rows = ad_cond_rows[ad_cond_rows['block'] == block].copy()

                    # values
                    trial_type = "ad_" + ad_cond
                    onset = block_cond_rows['onset'].min()

                    # save values to dictionary (append list for run key)
                    onsets_dict[trial_type][run_num].append(onset)

        # get image block onsets for each condition
        
        ## note: each food image conditions occur 1x per run (either after food or toy commercial),
        ## so there is no need to also loop by commercial type (just need extract which commercial condition it followed)
        
        for food_cond in ["hed_savory", "hed_sweet", "led_savory", "led_sweet"]:

            cond_rows = events_dat[events_dat['stim_file'].str.contains(food_cond)].copy()

            # get number of images for given condition
            n_jpeg_events = len(cond_rows)

            # if has image events
            if n_jpeg_events > 0:

                trial_type = food_cond + "_" + cond_rows['commercial_cond'].iloc[0] + "_cond" #all commerical conditions will be the same in cond_rows, just get the first with .iloc[0]
                onset = cond_rows['onset'].min()

                # save value to dictionary
                onsets_dict[trial_type][run_num].append(onset)

    # export onset files
    for trial_type_key in onsets_dict:
        
        # define path to outfuile
        out_file_path = Path(out_dir).joinpath('sub-' + sub + '_' + trial_type_key + '_onsets.txt')
        
        # get array of runs in ascending order
        runnum_keys_sorted = sorted(onsets_dict[trial_type_key].keys()) 

        # open a text file for writing
        with open(out_file_path, 'w') as file:

            # for each run
            for run_num in runnum_keys_sorted:

                # extract onset values
                onset_values = onsets_dict[trial_type_key][run_num]

                # row is '*' if no onset values, otherwise it is tab separated onsets
                if not onset_values:
                    row = "*"
                else: 
                    row = '\t'.join(str(x) for x in onset_values)

                # write row to file
                file.write(row + '\n')

    if return_onset_df is True:
        # return dictionary or dataframe? 
        # could return something that can go straight into gen_censored_onsets instead of needing to upload files?
        ## this would require something is returned for every subject? even if they have onset files? 
        return()
