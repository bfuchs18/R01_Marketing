#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
@author: baf44
"""

#set up packages    
from pickle import TRUE
import pandas as pd
import os
from pathlib import Path

##############################################################################
####                                                                      ####
####                             Core function                            ####
####                                                                      ####
##############################################################################

# for debugging
sub = 1
rawdata_dir = "/Users/bari/Library/CloudStorage/OneDrive-ThePennsylvaniaStateUniversity/b-childfoodlab_Shared/Active_Studies/MarketingResilienceRO1_8242020/ParticipantData/bids/rawdata"
analysis_dir = "/Users/bari/Library/CloudStorage/OneDrive-ThePennsylvaniaStateUniversity/b-childfoodlab_Shared/Active_Studies/MarketingResilienceRO1_8242020/ParticipantData/bids/derivatives/analyses/sst"
overwrite = True
return_onset_dict = True

def gen_sst_uncensored_onsets(sub, rawdata_dir, analysis_dir, overwrite = False, return_onset_dict = True):
    """
    This function creates uncensored onset files (AFNI format) for the SST for a given subject
    One onset file is generated for each of the following trial types: 
        succ_stop_food
        succ_stop_toy
        fail_stop_food
        fail_stop_toy
        succ_go_food
        succ_go_toy
        go_omis_food
        go_omis_toy
        incor_go_food
        incor_go_toy
        sst_block_food
        sst_block_toy
        ad_food
        ad_toy

    Inputs:
        sub 
        bids_dir (str) - path to bids_dir/ directory. Events files will be loaded from bids/rawdata/sub-{sub}/ses-1/func/
        analysis_dir (str) - path to output directory in bids/derivatives/analyses. Uncensored onset files will be exported into bids/derivatives/analyses/{analysis_dir}/level_1/sub-{sub}/onsets_uncensored/
        overwrite (boolean) - specify if output files should be overwritten (default = False)
        return_onset_dict (boolean) - specify if onset times should be returned in a dataframe
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
    
    # set rawdata_dir
    if isinstance(rawdata_dir, str):
        # make input string a path
        rawdata_dir = Path(rawdata_dir)
    else: 
        raise TypeError("rawdata_dir must be string")

    # set analysis_dir
    if isinstance(analysis_dir, str):
        # make input string a path
        analysis_dir = Path(analysis_dir)
    else: 
        raise TypeError("analysis_dir must be string")

    # check overwrite
    if not isinstance(overwrite, bool):
        raise TypeError("overwrite must be boolean (True or False)")

    # check return_onset_df
    if not isinstance(return_onset_dict, bool):
        raise TypeError("return_onset_dict must be boolean (True or False)")
    
    ##############
    ### Set up ###
    ##############

    # get list of events files
    events_files = list(Path(rawdata_dir).rglob('sub-' + str(sub) + '/ses-1/func/*sst*events.tsv'))

    # abort of no events files
    if len(events_files) < 1:
        print('No *events.tsv files found for sub ' + str(sub))
        raise Exception()

    ###############################################
    ### Extract onset times for each trial type ###
    ###############################################

    # get number of runs
    n_runs = len(events_files)

    # initialize nested dictionary with 1 dictionary per condition (key = run number, value = [])
    onsets_dict = {
    'succ_stop_food': {'run-0' + str(i): [] for i in range(1, n_runs + 1)},
    'succ_stop_toy': {'run-0' + str(i): [] for i in range(1, n_runs + 1)},
    'fail_stop_food': {'run-0' + str(i): [] for i in range(1, n_runs + 1)},
    'fail_stop_toy': {'run-0' + str(i): [] for i in range(1, n_runs + 1)},
    'succ_go_food': {'run-0' + str(i): [] for i in range(1, n_runs + 1)},
    'succ_go_toy': {'run-0' + str(i): [] for i in range(1, n_runs + 1)},
    'go_omis_food': {'run-0' + str(i): [] for i in range(1, n_runs + 1)},
    'go_omis_toy': {'run-0' + str(i): [] for i in range(1, n_runs + 1)},
    'incor_go_food': {'run-0' + str(i): [] for i in range(1, n_runs + 1)},
    'incor_go_toy': {'run-0' + str(i): [] for i in range(1, n_runs + 1)},
    'sst_block_food': {'run-0' + str(i): [] for i in range(1, n_runs + 1)},
    'sst_block_toy': {'run-0' + str(i): [] for i in range(1, n_runs + 1)},
    'ad_food': {'run-0' + str(i): [] for i in range(1, n_runs + 1)},
    'ad_toy': {'run-0' + str(i): [] for i in range(1, n_runs + 1)},
    }

    # loop though eventsfiles
    for file_path in events_files:

        # extract file basename
        file_name = file_path.name

        # extract run number from file name (format: 'run-0X')
        run = file_name.split("_")[3]

        #load data
        events_dat = pd.read_csv(str(file_path), sep = '\t', encoding = 'utf-8-sig', engine='python')

        # get ad condition for run
        ad_cond = events_dat['run_cond'][0]

        # ------- commerical block onsets ------
        #extract video rows
        video_rows = events_dat[events_dat['stim_file_name'].str.contains('mp4')].copy()

        # get number of video events -- will be zero if child aborted scan before any vid blocks finished
        n_vid_events = len(video_rows)

        # get video block onsets if there are video events
        if n_vid_events > 0:

            # define trial type
            trial_type = "ad_" + ad_cond
            
            # save values to dictionary (append list for run key)
            onsets_dict[trial_type][run] = video_rows['onset'].to_list()

        # ------- sst event onsets ------

        # subset rows for each trial type and save in dictionary
        event_rows_dict = {
            'succ_stop': events_dat[(events_dat['correct'] == 4) & (events_dat['signal'] == 1)].copy(),
            'fail_stop' : events_dat[events_dat['correct'] == 3].copy(),
            'succ_go' : events_dat[(events_dat['correct'] == 4) & (events_dat['signal'] == 0)].copy(),
            'incor_go' : events_dat[events_dat['correct'] == 2].copy(),
            'go_omis' : events_dat[events_dat['correct'] == 1].copy(),
        }

        # for each event type
        for event_type in event_rows_dict:

            # if there are events
            if len(event_rows_dict[event_type]) > 0:

                # define trial type
                trial_type = event_type + '_' + ad_cond

                # save values to dictionary (append list for run key)
                onsets_dict[trial_type][run] = event_rows_dict[event_type]['onset'].to_list()

        # ------- sst block onsets ------

        # extract onset for the first event (iloc[0]) in each of the 2 sst blocks
        block1_onset = events_dat[events_dat['block'] == 1]['onset'].iloc[0]
        block2_onset = events_dat[events_dat['block'] == 2]['onset'].iloc[0]
        
        # define trial type
        trial_type = "sst_block_" + ad_cond

        # save values to dictionary (append list for run key)
        onsets_dict[trial_type][run] = [block1_onset, block2_onset]

    ##########################
    ### Export onset files ###
    ##########################
    
    # define subject uncensored onset directory
    sub_onset_dir = os.path.join(analysis_dir, 'level_1/sub-' + str(sub) + '/onsets_uncensored/')

    # Make directory for export 
    Path(sub_onset_dir).mkdir(parents=True, exist_ok=True)
    
    for trial_type_key in onsets_dict:

        # define path to outfuile
        out_file_path = Path(sub_onset_dir).joinpath('sub-' + sub + '_' + trial_type_key + '_onsets.txt')

        if not out_file_path.exists() or overwrite:

            print('Exporting ' + trial_type_key + ' uncensored onset file for sub ' + str(sub))
            
            # get array of runs in ascending order
            runnum_keys_sorted = sorted(onsets_dict[trial_type_key].keys()) 

            # open a text file for writing
            with open(out_file_path, 'w') as file:

                # for each run
                for run in runnum_keys_sorted:

                    # extract onset values
                    onset_values = onsets_dict[trial_type_key][run]

                    # row is '* *' if no onset values, otherwise it is tab separated onsets
                    ## add asterick at the end of each row, because 1 column format is interpreted by AFNI as global times
                    if not onset_values:
                        row = "*\t*"
                    else: 
                        row = '\t'.join(str(x) for x in onset_values)  + '\t*'

                    # write row to file
                    file.write(row + '\n')

        else:
            print(trial_type_key + ' uncensored onset files already exist for sub ' + str(sub) + '. Use overwrite = True to overwrite')
            
    if return_onset_dict: 
       return(onsets_dict)
