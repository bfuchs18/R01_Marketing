#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
This function creates a TXT file with imaging covariates for group-level analyses in AFNI. 

@author: baf44
"""

#set up packages    
import pandas as pd
import os
from pathlib import Path
import shutil ## might need to add this to pandas conda env 

##############################################################################
####                                                                      ####
####                             Core Script                              ####
####                                                                      ####
##############################################################################
def gen_covariate_table():
    """Function to generate txt file with 1 row per subject and 1 column per covariate for use with 3dttest++ in AFNI. 
        Covariates to include in analyses can be specified via AFNI using column indexing.
    
    Rows in COVAR_FILE whose first column don't match a dataset label (e.g., in AFNI's gen_group_command.py for 3dttest++) are ignored (silently). 
        Thus, all subjects can be included in the covariate dataframe, even if they will not be included in analyses
    """

    # get script location
    script_path = Path(__file__).parent.resolve()

    # change directory to bids and get path
    os.chdir(script_path)
    os.chdir('../../../../')
    bids_path = Path(os.getcwd())

    bids_path = Path("/Users/bari/projects/Keller_Marketing/ParticipantData/bids/")

    bids_path = Path("/Users/bari/OneDrive - The Pennsylvania State University/b-childfoodlab_Shared/Active_Studies/MarketingResilienceRO1_8242020/ParticipantData/bids")

    #set specific paths
    phenotype_path = Path(bids_path).joinpath('phenotype/')
    database_path = Path(bids_path).joinpath('derivatives/analyses/foodview/databases/')

    # specify file names
    #anthro_file = 'anthropometrics.tsv'
    anthro_file = 'anthro_not_doubleentered.tsv'
    mri_file = 'mri_visit.tsv'

    ## file with average framewise displacement?

    # make database_path if it doesnt exist
    Path(database_path).mkdir(parents=True, exist_ok=True)

    # copy files from phenotype_path to database_path
    shutil.copyfile(Path(phenotype_path).joinpath(anthro_file), Path(database_path).joinpath(anthro_file))
    shutil.copyfile(Path(phenotype_path).joinpath(mri_file), Path(database_path).joinpath(mri_file))

    ##########################################
    #### Import and subset input databases ###
    ##########################################

    # anthro database
    anthro_df = pd.read_csv(Path(database_path).joinpath(anthro_file), sep='\t') # import as dataframe
    anthro_df = anthro_df[anthro_df['session_id'] == "ses-1"][['participant_id', 'sex', 'child_age', 'child_bmi_z', 'maternal_bmi', 'risk_status_maternal']] # subset to columns of interest for ses-1 only

    # mri variables
    mri_df = pd.read_csv(Path(database_path).joinpath(mri_file), sep='\t')  # import as dataframe
    mri_df = mri_df[['participant_id', 'cams_pre_mri', 'freddy_pre_mri']] # subset to columns of interest

    ###########################################
    #### Combine covariates into 1 database ###
    ###########################################

    covar_df = pd.merge(mri_df, anthro_df, on='participant_id', how='left') # left join -- only need to keep kids that have mri visit data

    # merge file with average framewise displacement?

    ############################
    #### Clean up covariates ###
    ############################

    # encode sex as -1 for male and 1 for female so that the main effect will be the average between males and females
    covar_df['sex'] = covar_df['sex'].map({'male':-1, 'female':1})

    # encode risk as -1 for low and 1 for high so that the main effect will be the average between risk groups
    covar_df['risk_status_maternal'] = covar_df['risk_status_maternal'].map({'low-risk':-1, 'high-risk':1})

    # # compute fat mass index -- can add this in one DEXA data is available
    # covar_df['dxa_total_fat_mass'] = covar_df['dxa_total_fat_mass'].astype(str).astype(float) #convert to string, then float
    # covar_df['height_avg'] = covar_df['height_avg'].astype(str).astype(float) #convert to string, then float
    # covar_df['fmi'] = (covar_df['dxa_total_fat_mass'].div(1000)) / ((covar_df["height_avg"] * .01)**2)

    # replace missing values with -999: AFNI cannot handle missing values and the entire table must be filled 
    covar_df.fillna(-999, inplace=True)

    #########################
    #### Export dataframe ###
    #########################

    # write dataframe with covariates
    covar_df.to_csv(str(Path(database_path).joinpath('covariates.txt')), sep = '\t', encoding='ascii', index = False)