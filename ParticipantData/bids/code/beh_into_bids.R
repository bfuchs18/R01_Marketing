# Process and organize data task and phenotype data into bids

# This script was written to process files stored in OneDrive, provided they are synced to a local computer and the script is run locally. 
# After processing data (which will be synced with OneDrive) locally, beh_into_bids.R syncs data to Roar Collab.
# This script could be modified to process data on Roar Collab by:
## (1) specifying the path to R01_Marketing on Roar Collab as base_dir
## (2) commenting out the section on syncing data (or, reversing source and destination directories to sync the other way)

#### load packages ####

# load dataREACHr
load_all("/Users/baf44/projects/dataREACHr")

#### user setup (modify variables here) ####

# define path to the ParticipantData directory on the local machine (synced with OneDrive)
base_dir = "/Users/baf44/Library/CloudStorage/OneDrive-ThePennsylvaniaStateUniversity/b-childfoodlab_Shared/Active_Studies/MarketingResilienceRO1_8242020/ParticipantData/"

# define names of redcap files to process
visit_file_name =  "FoodMarketingResilie_DATA_2024-05-20_1520.csv"
double_entry_file_name = "REACHDataDoubleEntry_DATA_2024-04-08_1306.csv"

# define Penn State user ID
## needed for syncing data between OneDrive and Roar Collab
user_id = "baf44"

#### process redcap data ####

# assign paths to data downloaded from redcap
visit_data_path = paste0(base_dir, "/bids/sourcedata/phenotype/", visit_file_name)
data_de_path = paste0(base_dir, "/bids/sourcedata/phenotype/", double_entry_file_name)

# process redcap data and export into bids/phenotype
redcap_data <-
  proc_redcap(visit_data_path,
              data_de_path,
              overwrite = TRUE,
              return_data = TRUE)

# run quality checks on redcap data
qc_redcap(redcap_data)

#### process task data ####
# process data: food view, sst ... 

task_data <-
  proc_task(
    base_wd = base_dir,
    overwrite_sourcedata = TRUE,
    overwrite_rawdata = TRUE,
    overwrite_jsons = TRUE,
    return_data = TRUE
  )

#### Sync data from OneDrive to RoarCollab ####

# to keep raw and processed phenotype/task data on Roar Collab up-to-date with OneDrive, it is recommended to update RoarCollab with rsync after re-processing.
# syncing data between OneDrive and Roar Collab requires having access to Roar Collab and Kathleen Keller's group folder

# define source and destination directories for rsync command
## source: untouchedRaw/ and bids/ One OneDrive
source_dir <- paste0(base_dir,"{untouchedRaw,bids}")
## destination: R01_Marketing on Roar Collab (submit.hpc.psu.edu)
destination_dir = paste0(user_id, "@submit.hpc.psu.edu:/storage/group/klk37/default/R01_Marketing")

# Build rsync command 
# TO DO: figure a way to sync without changing permissions 
rsync_cmd <- paste("rsync -av --update", source_dir, destination_dir)

# Execute rsync command - running this will prompt the user to enter their password
# system(rsync_cmd) ## commented out until permissions issue is resolved
