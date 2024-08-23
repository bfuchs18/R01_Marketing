#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
This script creates files that specify who to include in group-level analyses in AFNI. 

@author: baf44
"""

#set up packages    
import pandas as pd
import os
from pathlib import Path
import glob

##############################################################################
####                                                                      ####
####                             Core Script                              ####
####                                                                      ####
##############################################################################

# for debugging
bids_dir = "/Users/baf44/projects/Keller_Marketing/ParticipantData/bids/"
overwrite = True

## TO DO:
# add arg to specify covariates required -- right now ['participant_id', 'pre_cams_score', 'pre_mri_freddy_score' ,'sex', 'child_age', 'avg_fd_all_runs'] is hardcoded 
# add arg to specify run criteria 
# include run censor summary in process and label outfile based on requirement
# include QC results in process
# make separate lists for high and low risk

def gen_id_list(bids_dir, overwrite = False):
    """Function to generate file with list of subjects to included in group level-analyses in AFNI

    Inputs:
        bids_dir (str) - path to bids directory (e.g., "/Users/storage/group/klk37/default/R01_Marketing/bids/")
        overwrite (boolean) - specify if output file should be overwritten (default = False)

    Exports:
        level_2/id_list.tsv: tab-separated list of subjects
    """

    #######################
    ### Check arguments ###
    #######################

    if not isinstance(bids_dir, str):
        raise TypeError("required argument bids_dir must be a str")
   
    if not isinstance(overwrite, bool):
        raise TypeError("argument overwrite must be boolean (True or False)")
   

    #############################################
    #### Determine IDs that meet requirements ###
    #############################################

    # requirements
    # 1. has data for all covariates in given analysis
    # 2. has stats file for given analysis 
    # (future goal) 3. has X number of good runs censor summary motion file
    # (future goal) 4. has X number of good runs based on visual QC 

    # ----  make list of subs with stats files ----

    # inittialize list
    stats_subs = []

    # get list of files that match pattern (.../level_1/sub*/afniproc/*results/stats*.HEAD)
    stats_files = glob.glob(os.path.join(bids_dir, 'derivatives', 'analyses', 'foodview', 'level_1', 'sub-*', 'afniproc', '*results', 'stats*.HEAD'))

    for file_path in stats_files:

        stats_file = os.path.basename(file_path)
        sub = stats_file[6:13] # extract 'sub-???' from stats file name

        # append subID to list
        stats_subs.append(sub)


    # ----  make list of subs with covariate data ----

    # set path to level_2/, where covariates.txt exists
    lev2_path = Path(bids_dir).joinpath('derivatives/analyses/foodview/level_2/')

    # load covariate data in dataframe
    covar_df = pd.read_csv(Path(lev2_path).joinpath('covariates.txt'), sep='\t', na_values=-999) # import as dataframe

    # make list of covariates needed for analyses
    covariates = ['participant_id', 'pre_cams_score', 'pre_mri_freddy_score' ,'sex', 'child_age', 'avg_fd_all_runs']

    # subset dataframe to covariates for analyses and participant_id
    analysis_covar_df = covar_df[covariates]

    # get list of subjects in dataframe after removing rows with missing values
    cov_sub_nums = analysis_covar_df.dropna()['participant_id'].tolist()

    cov_subs = ['sub-' + str(sub).zfill(3) for sub in cov_sub_nums]

    # ---- make list of subs with at least 2 good runs  ----

    # import group censor summary data
    summary_file = os.path.join(lev2_path, 'compiled_censor-summary.tsv')
    summary_df = pd.read_csv(summary_file, sep='\t')

    # summarize run counts ... need to decide on criitera that will be used
    run_count = summary_df.groupby('sub').agg(
        total_runs=('sub', 'size'),
        runs_p_image_8=('p_uncensored_image_trs', lambda x: (x > 0.8).sum()),
        runs_p_image_7=('p_uncensored_image_trs', lambda x: (x > 0.7).sum()),
        runs_p_image_6=('p_uncensored_image_trs', lambda x: (x > 0.6).sum()),
        runs_p_all_8=('p_uncensored_trs', lambda x: (x > 0.8).sum()),
        runs_p_all_7=('p_uncensored_trs', lambda x: (x > 0.7).sum()),
        runs_p_all_6=('p_uncensored_trs', lambda x: (x > 0.6).sum()),
        runs_p_all_5=('p_uncensored_trs', lambda x: (x > 0.5).sum()),
        runs_p_comm_8=('p_uncensored_commerical_trs', lambda x: (x > 0.8).sum()),
        runs_p_comm_7=('p_uncensored_commerical_trs', lambda x: (x > 0.7).sum()),
        runs_p_comm_6=('p_uncensored_commerical_trs', lambda x: (x > 0.6).sum()),
        runs_p_comm_5=('p_uncensored_commerical_trs', lambda x: (x > 0.5).sum())
    ).reset_index()

    # get list of subs with CRITERIA
    sub_nums = run_count[run_count['runs_p_image_7'] > 2]['sub'].tolist()

    # format sub IDs
    data_subs = ['sub-' + str(sub).zfill(3) for sub in sub_nums]

    # ---- find subs that meet all criteria ----

    # convert stats_subs to set and take intersection with other lists 
    subs = set(stats_subs).intersection(cov_subs)
    
#    subs = set(stats_subs).intersection(cov_subs, data_subs)

    # format IDs for AFNI
    ## remove "sub-" prefix, convert to int
    ids = {int(sub.replace('sub-', '')) for sub in subs}
    
    ## get max digits 
    max_digits = len(str(max(ids)))

    ## pad IDs with zeros til length of max_digits
    ids = [str(id).zfill(max_digits) for id in ids]

    # export ----

    # set file name
    out_file = os.path.join(lev2_path, 'id_list.txt')

    # export if doesnt exist or overwrite is True
    if not Path(out_file).exists() or overwrite:
        print('Exporting level_2/id_list.txt')
        
        # write ids to file
        with open(out_file, 'w') as file:
            joined_list = "  ".join(ids)
            print(joined_list , file = file)
    else:
        print('level_2/id_list.txt exists. Use overwrite = True to overwrite')