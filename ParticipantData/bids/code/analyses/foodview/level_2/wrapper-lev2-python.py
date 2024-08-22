#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
This script was created to run python data processing functions for a given subject. Running this script requires 2 command line arguements:
(1) -s or --sub: integer with subject ID (e.g., -s 001)
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

# import data processing functions
import gen_group_avgfd_data
import gen_covariate_table
import gen_group_censor_summary
import gen_id_list


# process command line arguments
parser = argparse.ArgumentParser()
parser.add_argument("-d", "--bidsdir", help="string with path to bids directiry (e.g., '/path/to/bids/'")
args = parser.parse_args()

# check for command line args
if args.bidsdir is None:
    parser.print_help()
    sys.exit(1)  # Exit with a non-zero status indicating an error
else:
    bids_dir = args.bidsdir

# define strings with paths used as input in processing functions
analysis_dir = os.path.join(bids_dir, 'derivatives', 'analyses', 'foodview')


# call processing functions 
print("\n********************************************")
print(f"**** Running group-level python functions ****")
print("***********************************************")

print("\n*** Running function to compile avg framewise displacement data across subs ***")
gen_group_avgfd_data.gen_group_avg_data(analysis_dir = analysis_dir, overwrite=False)

print("\n*** Running function to XXXX ***")
gen_covariate_table.gen_uncensored_onsets(analysis_dir = analysis_dir, overwrite=False)

print("\n*** Running function to XXXX ***")
gen_group_censor_summary.gen_uncensored_onsets(analysis_dir = analysis_dir, overwrite=False)

print("\n*** Running function to XXXX ***")
gen_id_list.gen_uncensored_onsets(analysis_dir = analysis_dir, overwrite=False)
