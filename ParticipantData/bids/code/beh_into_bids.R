# Process and organize data into bids

#### setup ####

# load dataREACHr
load_all("/Users/baf44/projects/dataREACHr")

# set path to base directory (contains bids/ and untouchedRaw/)
# base_dir <- "/Users/baf44/projects/Keller_Marketing/ParticipantData/"
base_dir <- "/Users/baf44/Library/CloudStorage/OneDrive-ThePennsylvaniaStateUniversity/b-childfoodlab_Shared/Active_Studies/MarketingResilienceRO1_8242020/ParticipantData/"

#### process redcap data ####

# set redcap file names
visit_file_name =  "FoodMarketingResilie_DATA_2024-05-02_1044.csv"
double_entry_file_name = "REACHDataDoubleEntry_DATA_2024-04-08_1306.csv"

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
