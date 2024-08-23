#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
@author: baf44
"""

#set up packages    
import os
from pathlib import Path
import pandas as pd

# for debugging
analysis_dir = "/Users/baf44/projects/Keller_Marketing/ParticipantData/bids/derivatives/analyses/foodview"
tsv_identifier = "avg-fd"
overwrite = True

def compile_lev1_tsv(analysis_dir, tsv_identifier, overwrite = False):
    """
    This functions generates a compiled dataset of level_1 TSV files identified based on tsv_identifier. 

    Inputs:
        tsv_identifier (str) - input to rglob to identify TSV files that match 'level_1/sub*/*{tsv_identifier}*.tsv' to compile (e.g., "avg-fd", "censor-summary")
        analysis_dir (str) - path to directory in bids/derivatives/analyses (e.g., "/Users/storage/group/klk37/default/R01_Marketing/bids/derivatives/analyses/foodview")
        overwrite (boolean) - specify if output file should be overwritten (default = False)

    Exports:
        level_2/compiled_{tsv_identifier}.tsv: TSV with compiled data for all participants with level_1/sub*/*{tsv_identifier}*tsv
    """

    #######################
    ### Check arguments ###
    #######################

    if not isinstance(analysis_dir, str):
        raise TypeError("required argument analysis_dir must be a str")
   
    if not isinstance(tsv_identifier, str):
        raise TypeError("required argument tsv_identifier must be a str")
   
    if not isinstance(overwrite, bool):
        raise TypeError("argument overwrite must be boolean (True or False)")
   
    #######################
    ### Compile data ###
    #######################

    # get list of level_1 files to compile
    r_glob_str = 'level_1/sub*/*' + tsv_identifier + '*.tsv'
    sub_files = list(Path(analysis_dir).rglob(r_glob_str))

    # quit if no files sub_files
    if not sub_files:
        print('No files matching pattern ' + analysis_dir + '/' + r_glob_str + '. Check analysis_dir and tsv_identifier arguments')
        raise Exception()

    # initialize list to save subject dataframes to
    dataframe_list = []

    # create list of dataframes with subject data
    for file_path in sub_files:

        # extract file basename
        file_name = file_path.name

        #load subject's data as a dataframe
        sub_data = pd.read_csv(str(file_path), sep = '\t', encoding = 'utf-8-sig', engine='python')

        ## append dataframe to list
        dataframe_list.append(sub_data)

    # concatenate all dataframes into a single dataframes
    group_data = pd.concat(dataframe_list, ignore_index=True)

    # Make directory for export 
    Path(os.path.join(analysis_dir, 'level_2')).mkdir(parents=True, exist_ok=True)

    # define output file path
    file_name = Path(os.path.join(analysis_dir, 'level_2', 'compiled_' + tsv_identifier + '.tsv'))

    # export if doesnt exist or overwrite is True
    if not file_name.exists() or overwrite:
        print('Exporting level_2/' + str(file_name.name))
        group_data.to_csv(str(file_name), sep = '\t', encoding='ascii', index = False, header=True)
    else:
        print('level_2/' + str(file_name.name) + ' exists. Use overwrite = True to overwrite')