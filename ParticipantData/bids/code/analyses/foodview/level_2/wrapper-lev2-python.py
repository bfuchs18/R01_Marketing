#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
This script was created to run group-level python data processing functions. Running this script requires 1 command line arguements:
(1) -d or --bids-dir: string with path to bids directiry (e.g., -d "/path/to/bids/")

By taking command line arguments, this script can be run via a SLURM script

@author: baf44
"""
# usage on roar collab (use default for -d):
# >> conda activate pandas
# >> python3 wrapper-lev2-python.py

# for testing locally:
# >> python3 wrapper-lev2-python.py -d "/Users/baf44/Library/CloudStorage/OneDrive-ThePennsylvaniaStateUniversity/b-childfoodlab_Shared/Active_Studies/MarketingResilienceRO1_8242020/ParticipantData/bids"

#set up packages    
import os
import argparse

# import data processing functions
import compile_lev1_tsv
import gen_covariate_table
import gen_id_list


# process command line arguments
parser = argparse.ArgumentParser()
parser.add_argument("-d", "--bidsdir", help="string with path to bids directory (e.g., '/path/to/bids/'", default="/storage/group/klk37/default/R01_Marketing/bids/")
args = parser.parse_args()

# set bids_dir base on command line arg
bids_dir = args.bidsdir

# define strings with paths used as input in processing functions
analysis_dir = os.path.join(bids_dir, 'derivatives', 'analyses', 'foodview')


# call processing functions 
print("\n***********************************************")
print(f"**** Running group-level python functions *****")
print("***********************************************")


print("\n*** Running function to compile level_1 avg-fd data across subs ***")
compile_lev1_tsv.compile_lev1_tsv(analysis_dir = analysis_dir, tsv_identifier='avg-fd', overwrite=True)

print("\n*** Running function to compile level_1 censor-summary data across subs ***")
compile_lev1_tsv.compile_lev1_tsv(analysis_dir = analysis_dir, tsv_identifier='censor-summary', overwrite=True)

print("\n*** Running function to generate covariate table ***")
gen_covariate_table.gen_covariate_table(bids_dir = bids_dir, overwrite=True)

print("\n*** Running function to generate ID file ***")
gen_id_list.gen_id_list(bids_dir = bids_dir, overwrite=True)
