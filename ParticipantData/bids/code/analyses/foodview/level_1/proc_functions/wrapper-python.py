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
import gen_uncensored_onsets
import gen_censor_files
import gen_regressor_file
import gen_censored_onsets
import gen_censor_summary

# process command line arguments
parser = argparse.ArgumentParser()
parser.add_argument("-s", "--sub", type=int, help="subject ID (e.g., 001)")
parser.add_argument("-d", "--bidsdir", help="string with path to bids directiry (e.g., '/path/to/bids/'")
args = parser.parse_args()

if args.sub is None or args.bidsdir is None:
    parser.print_help()
    sys.exit(1)  # Exit with a non-zero status indicating an error
else:
    sub = str(args.sub).zfill(3)
    bids_dir = args.bidsdir

# define strings with paths for processing fucntions
rawdata_dir = os.path.join(bids_dir, 'rawdata/')
fmriprep_dir = os.path.join(bids_dir, 'derivatives', 'preprocessed', 'fmriprep_v2320')
analysis_dir = os.path.join(bids_dir, 'derivatives', 'analyses', 'foodview')

# call processing functions

try:
    uncensored_onsets_dict = gen_uncensored_onsets.gen_uncensored_onsets(sub = sub, rawdata_dir = rawdata_dir, analysis_dir = analysis_dir, overwrite=False)
except:
    print("Discontinuing gen_uncensored_onsets() for sub-" + sub)

try:
    gen_regressor_file.gen_regressor_file(sub = sub, fmriprep_dir = fmriprep_dir, analysis_dir = analysis_dir, overwrite = False)
except:
    print("Discontinuing gen_regressor_file() for sub-" + sub)

try:
    censor_files = gen_censor_files.gen_censor_files(sub = sub, fmriprep_dir = fmriprep_dir, analysis_dir = analysis_dir, overwrite = False)
except:
    print("Discontinuing gen_censor_files() for sub-" + sub)

### TO DO: write this function to generate a censor summary based on uncensored_onsets_dict and censor_files

# try:
#     censor_summary = gen_censor_summary.gen_censor_summary(sub = sub, uncensored_onsets_dict = uncensored_onsets_dict, censor_files = censor_files, analysis_dir = analysis_dir, overwrite = False)
# except:
#     print("Discontinuing gen_censor_summary() for sub-" + sub)

### TO DO: write this function to generate censored onsets given censor_summary and a given criteria

# try:
#     gen_censored_onsets.gen_censored_onsets(sub = sub, censor_summary = censor_summary, run_criteria = XX, analysis_dir = analysis_dir, overwrite = False)
# except:
#     print("Discontinuing gen_censored_onsets() for sub-" + sub)