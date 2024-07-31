#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
This script generates a dataset with censor summary info for all participants with censor_summary file. Running this script requires 2 command line arguements:
(1) 
(2) -d or --bids-dir: string with path to bids directiry (e.g., -d "/path/to/bids/")

By taking command line arguments, this script can be run via a SLURM script

@author: baf44
"""
# for testing locally:
# -d "/Users/bari/Library/CloudStorage/OneDrive-ThePennsylvaniaStateUniversity/b-childfoodlab_Shared/Active_Studies/MarketingResilienceRO1_8242020/ParticipantData/bids"

#set up packages    
import sys
import os
import argparse
from pathlib import Path
import pandas as pd
import csv

# # process command line arguments
# parser = argparse.ArgumentParser()
# parser.add_argument("-s", "--sub", type=int, help="subject ID (e.g., 001)")
# parser.add_argument("-d", "--bidsdir", help="string with path to bids directiry (e.g., '/path/to/bids/'")
# args = parser.parse_args()

# if args.sub is None or args.bidsdir is None:
#     parser.print_help()
#     sys.exit(1)  # Exit with a non-zero status indicating an error
# else:
#     sub = str(args.sub).zfill(3)
#     bids_dir = args.bidsdir

bids_dir = "/storage/group/klk37/default/R01_Marketing/bids/"

# define strings with paths for processing fucntions
analysis_dir = os.path.join(bids_dir, 'derivatives', 'analyses', 'foodview')

# get list of events files
sub_summary_files = list(Path(analysis_dir).rglob('sub*/*censor-summary*.tsv'))

# initialize list to save subject dataframes to
dataframe_list = []

# create list of dataframes with subject data
for file_path in sub_summary_files:

    # extract file basename
    file_name = file_path.name

    #load subject's summary data as a dataframe
    sub_summary_data = pd.read_csv(str(file_path), sep = '\t', encoding = 'utf-8-sig', engine='python')

    # append dataframe to list
    dataframe_list.append(sub_summary_data)

# concatenate all dataframes into a single dataframes
group_data = pd.concat(dataframe_list, ignore_index=True)
