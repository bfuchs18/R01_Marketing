# Process and organize survey (Redcap) and task data into bids

library(dataREACHr)

#### process redcap data ####

# assign paths to data downloaded from redcap
visit_data_path = "/Users/baf44/projects/Keller_Marketing/ParticipantData/bids/sourcedata/phenotype/FoodMarketingResilie_DATA_2024-03-22_1446.csv"
data_de_path = "/Users/baf44/projects/Keller_Marketing/ParticipantData/bids/sourcedata/phenotype/REACHDataDoubleEntry_DATA_2024-03-12_1045.csv"

# process redcap data and export into bids/phenotype
proc_redcap(visit_data_path, data_de_path, overwrite = FALSE, return_data = FALSE)

#### process task (foodview, sst) data ####

# assign path to base directory, which contains untouchedRaw/ and bids/
base_wd = "/Users/baf44/projects/Keller_Marketing/ParticipantData/"

# # move task data from untouchedRaw into bids/sourcedata
# util_org_sourcedata(base_wd, overwrite = FALSE)
# 
# # process Food View task data and export into bids/rawdata
# for (sub in subs) {
#   # 
# }