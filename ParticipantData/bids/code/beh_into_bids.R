# Script to process and organize data task and phenotype data into bids; create task database derivatives 

# This script was written with the goal of processing data locally (i.e., with OneDrive files synced to your computer). 
# After processing, this script will print an rsync command into the console, which should be pasted into a terminal and run to sync data with Roar Collab (password will be required)

# Before running this script
## (1) update config_redcap_sourcedata.R with the names of REDCap files to process (config_redcap_sourcedata.R is sourced by this script)
## (2) update 'base_dir' (variable in beh_into_bids.R) with the path to ParticipantData/ on the local machine (synced with OneDrive)
## (3) update 'user_id' (variable in beh_into_bids.R) with your Penn State User ID to get the correct rsync command 


# load packages -----

# load dataREACHr (load_all() from devtools package)
library(devtools)
load_all("/Users/baf44/projects/dataREACHr")

# user setup (modify variables here) -----

# define path to the ParticipantData directory on the local machine (synced with OneDrive)
base_dir = "/Users/baf44/Library/CloudStorage/OneDrive-ThePennsylvaniaStateUniversity/b-childfoodlab_Shared/Active_Studies/MarketingResilienceRO1_8242020/ParticipantData/"

# define names of redcap files to process
source("ParticipantData/bids/code/config_redcap_sourcedata.R")

# define Penn State user ID
## needed for syncing data between OneDrive and Roar Collab
user_id = "baf44"

# process redcap data -----

# assign paths to data downloaded from redcap
visit_data_path = file.path(base_dir, "bids", "sourcedata", "phenotype", visit_file_name)
data_de_path = file.path(base_dir, "bids", "sourcedata", "phenotype", double_entry_file_name)

# process redcap data and export into bids/phenotype
print("** Processing survey data with proc_redcap() **")

redcap_data <-
  proc_redcap(visit_data_path,
              data_de_path,
              overwrite = TRUE,
              return_data = TRUE)

## run quality checks on redcap data -----
qc_redcap(redcap_data)

# assess double-entry discrepancies
de_discrepancies <- redcap_data$double_entry_data$discrepancies
print("** Double-entry Discrepancies **")
print(de_discrepancies)

# process task data -----
print("** Processing task data with proc_task() **")

task_data <-
  proc_task(
    base_wd = base_dir,
    overwrite_sourcedata = FALSE,
    overwrite_rawdata = FALSE,
    overwrite_jsons = TRUE,
    return_data = TRUE
  )

# generate derivative task databases -----
print("** Creating derivative databases with proc_task_derivs() **")
      
# create directory for summary beh data if it doesn't exist
beh_sum_dir <- paste0(base_dir, "/bids/derivatives/beh_summary_databases/")

if (!dir.exists(beh_sum_dir)) {
  dir.create(beh_sum_dir, recursive = TRUE)
}

proc_task_derivs(task_data = task_data, export_dir = beh_sum_dir) # creates derivatives for sst, rrv, foodview

# Sync data from OneDrive to RoarCollab -----

# to keep raw and processed phenotype/task data on Roar Collab up-to-date with OneDrive, it is recommended to update RoarCollab with rsync after re-processing.
# syncing data between OneDrive and Roar Collab requires having access to Roar Collab and Kathleen Keller's group folder

# define destination directory for rsync command
destination_dir = paste0(user_id, "@submit.hpc.psu.edu:/storage/group/klk37/default/R01_Marketing")

# Build rsync command 
rsync_cmd <-
  paste(
    "rsync -av --relative --update --perms --chmod=a+rX,ug+w", # set permissions to 775
    paste0(base_dir, "/./untouchedRaw"), # /./ is used with --relative, only the part after the dot is copied into destination_dir 
    paste0(base_dir, "/./bids/rawdata"),
    paste0(base_dir, "/./bids/phenotype"),
    paste0(base_dir, "/./bids/sourcedata"),
    paste0(base_dir, "/./bids/derivatives/beh_summary_databases"),
    destination_dir
  )

# system(rsync_cmd)
# TO DO: figure a way to specify group (klk37_collab)/permissions of files during or after syncing 
# until then, ssh in and use chgrp -R klk37_collab *

print("")
print("**copy and paste the following command into a terminal to sync untouchedRaw and processed data. You will be prompted for a password.**")
print(rsync_cmd)