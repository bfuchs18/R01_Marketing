# Process and organize data task and phenotype data into bids

#### load packages ####

# load dataREACHr
load_all("/Users/baf44/projects/dataREACHr")

#### user setup (modify variables here) ####

# set path to ParticipantData directory on OneDrive (contains bids/ and untouchedRaw/)
base_dir = "/Users/baf44/Library/CloudStorage/OneDrive-ThePennsylvaniaStateUniversity/b-childfoodlab_Shared/Active_Studies/MarketingResilienceRO1_8242020/ParticipantData/"

# set redcap file names
visit_file_name =  "FoodMarketingResilie_DATA_2024-05-03_1132.csv"
double_entry_file_name = "REACHDataDoubleEntry_DATA_2024-04-08_1306.csv"

# Penn State user ID
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

#### process task data ####
# process data: food view, sst ... 

task_data <-
  proc_task(
    base_wd = base_dir,
    overwrite_parsed_rrv = FALSE,
    overwrite_sourcedata = FALSE,
    overwrite_rawdata_vector = c("all_tasks"),
    #overwrite_rawdata_vector = c(),
    overwrite_jsons = FALSE,
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
rsync_cmd <- paste("rsync -av --update", source_dir, destination_dir)

# Execute rsync command - running this will prompt the user to enter their password
system(rsync_cmd)
