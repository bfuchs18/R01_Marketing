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
# #def gen_id_list():

# """Function to generate list of subjects to included in group level-analyses. 

# List is exported as a tab-separated TXT file that can be pointed to in AFNI scripts.

# """

# get script location
script_path = Path(__file__).parent.resolve()

# change directory to bids and get path
os.chdir(script_path)
os.chdir('../../../../')
bids_path = Path(os.getcwd())

# for testing locally
#bids_path = Path("/Users/bari/OneDrive - The Pennsylvania State University/b-childfoodlab_Shared/Active_Studies/MarketingResilienceRO1_8242020/ParticipantData/bids")
#bids_path = Path("/Users/bari/projects/Keller_Marketing/ParticipantData/bids")
bids_path = Path("/storage/group/klk37/default/R01_Marketing/bids/")

#################################
#### Determine who to include ###
#################################

# requirements
# 1. has data for all covariates in given analysis
# 2. has stats file for given analysis 
# 3. has X number of good runs censor summary motion file
# (future goal) 4. has X number of good runs based on visual QC 

# ----  make list of subs with stats files ----

# inittialize list
stats_subs = []

# define string with wildcard to get stats files
results_folder_str = os.path.join(bids_path, 'derivatives', 'analyses', 'foodview', 'level_1', 'sub-*', 'afniproc', '*results', '*stats.HEAD')

for file_path in glob.glob(results_folder_str):

    stats_file = os.path.basename(file_path)
    sub = stats_file[6:13] # extract 'sub-???' from stats file name

    # append subID to list
    stats_subs.append()

# ----  make list of subs with covariate data ----

# load covariate data in dataframe
covar_file = os.path.join(bids_path, 'derivatives', 'analyses', 'foodview', 'databases', 'covariates.txt')
covar_df = pd.read_csv(covar_file, sep='\t', na_values=-999) # specify that NA values are coded as -999

# make list of covariates needed for analyses
covariates = ['participant_id', 'sex', 'child_age']

# subset dataframe to covariates for analyses and participant_id
analysis_covar_df = covar_df[covariates]

# get list of subjects in dataframe after removing rows with missing values
cov_subs = analysis_covar_df.dropna()['participant_id'].tolist()

# ---- make list of subs with at least 2 good runs  ----

# import group censor summary data
summary_file = os.path.join(bids_path, 'derivatives', 'analyses', 'foodview', 'level_2', 'group_censor_summary.tsv')
summary_df = pd.read_csv(summary_file, sep='\t')

sub = str(sub).zfill(3)

# summarize run counts ... need to decide on criitera that will be used
run_count = summary_df.groupby('sub').agg(
    total_runs=('sub', 'size'),
    runs_p_image_8=('p_uncensored_image_trs', lambda x: (x > 0.8).sum()),
    runs_p_image_7=('p_uncensored_image_trs', lambda x: (x > 0.7).sum()),
    runs_p_image_6=('p_uncensored_image_trs', lambda x: (x > 0.6).sum()),
    runs_p_image_5=('p_uncensored_image_trs', lambda x: (x > 0.5).sum()),
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
sub_nums = run_count[run_count['runs_p_all_7'] > 2]['sub'].tolist()

# format sub IDs
data_subs = ['sub-' + str(sub).zfill(3) for sub in sub_nums]

# ---- find subs that meet all criteria ----

# convert stats_subs to set and take intersection with other lists 
subs = set(stats_subs).intersection(cov_subs, data_subs)

# export