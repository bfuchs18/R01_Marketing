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
#import gen_regressor_file
#import gen_censor_summary
#import gen_censored_onsets


# process command line arguments
parser = argparse.ArgumentParser()
parser.add_argument("-s", "--sub", type=int, help="subject ID (e.g., 001)")
parser.add_argument("-d", "--bidsdir", help="string with path to bids directiry (e.g., '/path/to/bids/'")
args = parser.parse_args()

# check for command line args
if args.sub is None or args.bidsdir is None:
    parser.print_help()
    sys.exit(1)  # Exit with a non-zero status indicating an error
else:
    sub = str(args.sub).zfill(3)
    bids_dir = args.bidsdir

# define strings with paths used as input in processing functions
rawdata_dir = os.path.join(bids_dir, 'rawdata')
fmriprep_dir = os.path.join(bids_dir, 'derivatives', 'preprocessed', 'fmriprep_v2401')
analysis_dir = os.path.join(bids_dir, 'derivatives', 'analyses', 'sst')


# call processing functions 
print("\n*****************************************************************")
print(f"**** Starting SST python processing for sub-{sub} ****")
print("*****************************************************************")

print("\n*** Running function to generate uncensored onset files ***")
uncensored_onsets_dict = gen_uncensored_onsets.gen_uncensored_onsets(sub = sub, rawdata_dir = rawdata_dir, analysis_dir = analysis_dir, overwrite=False, return_onset_dict = True)

#print("\n*** Running function to generate nuissance regressor file ***")
#gen_regressor_file.gen_regressor_file(sub = sub, fmriprep_dir = fmriprep_dir, analysis_dir = analysis_dir, overwrite = False)

print("\n*** Running function to generate censor files ***")
censordata_dict = gen_censor_files.gen_censor_files(sub = sub, fmriprep_dir = fmriprep_dir, analysis_dir = analysis_dir, overwrite = False, return_censordata_dict = True) # use default fd_thresh (.9)

#print("\n*** Running function to generate censor summary file ***")
#censor_summary_dataframe = gen_censor_summary.gen_censor_summary(sub = sub, uncensored_onsets_dict = uncensored_onsets_dict, censordata_dict = censordata_dict, analysis_dir = analysis_dir, overwrite = False, return_summary_dataframe = True) # use default fd_thresh (.9)

#print("\n*** Running function to generate censored onset file ***")
#gen_censored_onsets.gen_censored_onsets(sub = sub, uncensored_onsets_dict = uncensored_onsets_dict, censor_summary_dataframe = censor_summary_dataframe, p_uncensored_trs_thresh = False, p_uncensored_image_trs_thresh = .5, analysis_dir = analysis_dir, overwrite=False) # use default fd_thresh (.9)
