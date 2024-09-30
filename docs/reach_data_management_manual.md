<!-- omit in toc -->
# Data Manual - Study REACH

- [Introduction](#introduction)
  - [Using the data](#using-the-data)
    - [General usage notes](#general-usage-notes)
    - [Using phenotype data](#using-phenotype-data)
      - [Combining datasets](#combining-datasets)
    - [Using rawdata](#using-rawdata)
    - [Using derivative data](#using-derivative-data)
  - [Correcting data entry/collection errors](#correcting-data-entrycollection-errors)
- [Data Management](#data-management)
  - [Directory Organization](#directory-organization)
    - [untouchedRaw](#untouchedraw)
    - [bids](#bids)
    - [bids/sourcedata](#bidssourcedata)
    - [bids/rawdata](#bidsrawdata)
    - [bids/phenotype](#bidsphenotype)
    - [bids/derivatives](#bidsderivatives)
    - [bids/code](#bidscode)
  - [Data Processing Software](#data-processing-software)
    - [R01\_Marketing](#r01_marketing)
    - [dataREACHr](#datareachr)
    - [dataprepr](#dataprepr)
    - [dcm2bids](#dcm2bids)
    - [pydeface](#pydeface)
    - [mriqc](#mriqc)
    - [fmriprep](#fmriprep)
    - [afni](#afni)
  - [Data Processing Pipeline](#data-processing-pipeline)
    - [Overview](#overview)
    - [Required access](#required-access)
    - [Retriving data from the source](#retriving-data-from-the-source)
      - [Survey (redcap) data](#survey-redcap-data)
      - [Task data](#task-data)
      - [MRI data](#mri-data)
    - [MRI data processing example for subject 001](#mri-data-processing-example-for-subject-001)
    - [Explanation of MRI data processing steps](#explanation-of-mri-data-processing-steps)
    - [Organizing data into BIDS with processing scripts](#organizing-data-into-bids-with-processing-scripts)
      - [Survey and Task Data](#survey-and-task-data)
    - [Neuroimaging data](#neuroimaging-data)
      - [Example processing for sub 001](#example-processing-for-sub-001)
  - [Data Quality Control](#data-quality-control)
      - [Survey data](#survey-data)
      - [MRI data](#mri-data-1)
  - [Data Documentation](#data-documentation)
  - [Pre-Processing Pipeline](#pre-processing-pipeline)
    - [Pipeline Execution](#pipeline-execution)
      - [1) Raw Data](#1-raw-data)
        - [1a) Exporting](#1a-exporting)
        - [1b) Quality Control](#1b-quality-control)
      - [2) ...](#2-)
- [Interactive Reports and Tables](#interactive-reports-and-tables)
- [Analyses: Guidelines for Reproducibility and Documentation](#analyses-guidelines-for-reproducibility-and-documentation)


# Introduction

## Using the data

### General usage notes


1. Never manually edit datasets in bids/rawdata, bids/phenotype, and bids/derivatives. 
   - This is because: (1) data are organized and processed using scripts found in bids/code. When datasets are re-processed or updated using these scripts, manual edits will be overwritten; and (2) these data are shared. Someone else using the datasets may be unaware of changes you made.
2. Reference .json files to understand the datasets.
   - JSON files (i.e., files with .json extension) contain metadata for corresponding .tsv files. Meta-data includes information such as variable descriptions and citations.
   - Within bids/phenotypes/, each TSV file is accompanied by a corresponding JSON file with the same basename 
   - Within bids/rawdata/, meta-data for task TSV files in subject/session sub-folders are stored directly in bids/rawdata.
     - E.g., metadata for /bids/rawdata/sub-001/ses-1/beh/sub-001_ses-1_task-sst_beh.tsv can be found within /bids/rawdata/task-sst_beh.json 
3. ??? Reference notes to understand the data ??? 
   1. To do: add something about where qualitative notes will be kept?? in specific databases or a notes database?? 
4. Specify 'n/a' as the value for missing data
  - In compliance with BIDS, 'n/a' is used to indicate missing data in rawdata and derivatives datasetes. To prevent software from interpreting 'n/a' as a string rather than missing data, it can be helpful to specify 'n/a' as the value to set as missing.

In R missing values can be specified at import:
```
# specify file path (update path to file)
path_to_file <- paste0('path/to/file.tsv')

# import data from TSV, specifying missing data values as "n/a"
data <- read.delim(path_to_file, na.strings = "n/a")
```

In SPSS missing values can be specified using the MISSING VALUES command. 


### Using phenotype data

#### Combining datasets
All datasets in bids/phenotype/ contain participant_id and session_id columns that indicate the subject identifier (e.g., sub-001) and when data were collected (i.e., ses-1/baseline or ses-2/follow-up), respectively. Data collected across multiple visits are stored in long format, meaning that within a dataset, a subject has a separate row for each session. Therefore, datasets can be merged by both participant_id and session_id columns.

Example: merge data in R, matching on participant_id and session_id
```
# load demo data
demo_data <- read.delim('path/to/demographics.tsv')

#  example demo_data:
#  participant_id session_id age
#           1     1          7
#           2     1          7
#           1     2          8
#           2     2          8

# load cebq data
cebq_data <- read.delim('path/to/cebq.tsv')

#  example cebq_data:
#  participant_id session_id cebq_value
#           1     1          3
#           2     1          2
#           1     2          1
#           2     2          5

# merge demographic and cebq data
merged_data <- merge(demo_data, cebq_data, by=c("participant_id","session_id"))

#  example merged_data:
#  participant_id session_id age  cebq_value
#           1     1          7      3
#           2     1          7      2
#           1     2          8      1
#           2     2          8      5

```

Example: merge data in SPSS
```

```

### Using rawdata

To do: recommendations for creating derivative datasets from rawdata? 

### Using derivative data


## Correcting data entry/collection errors

Data in bids/ are organized and processed using scripts found in bids/code. When datasets are re-processed or updated using these scripts, manual edits will be overwritten. Therefore data entry errors need to be fixed where data are stored prior to processing:
- For errors in phenotype/survey data, data need to be updated in REDCap. Then, REDCap data can be re-downloaded and reprocessed using dataREACHr
  - Example error in REDCap data: Values that were incorrectly transferred from paper to REDCap (e.g., anthropometrics, intake measurements)
- For errors in task data, data need to be updated in untouchedRaw. Then, they can be reprocessed into bids using dataREACHr
  - Example error in task data: data was improperly exported from task software  



# Data Management

##  Directory Organization

Data are stored on 2 servers:

1. OneDrive (The cloud storage service used by Penn State)
2. Roar Collab (Penn State's High Performance Computing Cluster)

Survey and task data are stored on both servers, while imaging data is stored on Roar Collab only (due to file size).

Data on OneDrive are stored in the folder: 
b-childfoodlab_Shared > Active_Studies > MarketingResilienceRO1_8242020 > ParticipantData

Data
on Roar Collab are stored in the folder:
storage > group > klk37 > default > R01_Marketing

On OneDrive, the directory structure looks like:
- b-childfoodlab_Shared
  - Active_Studies
    - MarketingResilienceRO1_8242020
      - ParticipantData
         - **untouchedRaw**
         - **bids**
           - **sourcedata**
           - **rawdata**
           - **phenotype**
           - **derivatives**
           - **code**
  
On Roar Collab, the directory structure looks like:
- storage
  - group
    - klk37
      - default
        - R01_Marketing 
           - **untouchedRaw**
           - **bids**
             - **sourcedata**
             - **rawdata**
             - **phenotype**
             - **derivatives**
             - **code**

Notice that the sub-directories within ParticipantData/ (on OneDrive) and R01_Marketing/ (on Roar Collab) are the same. This enables syncing files in untouchedRaw/ and bids/ between the servers. The contents of these folders are summarized in Table 2 and detailed in subsections below.

Table 2. Data directories and descriptions
| Directory    | Description |
| -------- | ------- |
| untouchedRaw  |  Contains task data in its rawest form. Data in this folder serves as a backup and should never be directly worked from.  |
| bids | Contains survey*, task, and neuroimaging data across differnt stages of processing, organized according to BIDS standards   |
| bids/sourcedata    | Contains copies of task and neuroimaging data from untouchedRaw and survey data downloaded from redcap. Data in this folder will be organized into bids/rawdata and bids/phenotype 
| bids/rawdata    | Contains task and neuroimaging data organized according to BIDS standards|
| bids/phenotype    | Contains survey data organized according to BIDS standards |
| bids/derivatives    | Contains processed data or generated datasets |
| bids/code    | Contains code to organize and process data within bids/ |

\* Survey refers to data collected in survey format via redcap, including questionnaires and researcher-entered data (e.g., intake measurements) 


### untouchedRaw

untouchedRaw/ contains task and MRI data transferred directly from the source. For task data, the source is where the task program exports the data; for imaging (DICOM) data, the source is where SLEIC uploads the data. untouchedRaw/ is organized by task, such that data for each task is found within a task-specific folder:

  - untouchedRaw
    - foodview_task
    - hrv
    - nih-toolbox
    - pit_task
    - rrv_task
    - rsa
    - space_game
    - sst
    - tictach_task
    - DICOMS * 

*DICOMS are stored on Roar Collab only due to size

### bids

Data within bids/ are organized to comply with the [Brain Imaging Data Structure](https://bids.neuroimaging.io/). 

### bids/sourcedata

bids/sourcedata/ contains copies of data from untouchedRaw/. However, data are now organized by subject and session: each subject has a folder (sub-{label}) in /sourcedata, and within each subject folder are session folders (ses-{label}). Session folders  separate data collected at baseline (REACH visits 1 through 4) and follow-up (REACH visit 5). Within session folders, task data are stored in beh/ and MRI data are stored in dicom/. 

bids/sourcedata/ also contains survey data downloaded from REDCap, stored in /phenotype.

This looks like: 
- bids
  - sourcedata
    - sub-{label}
      - ses-1
        - dicom
          - [Imaging data collected at baseline]
        - beh
          - [Task files collected at baseline]
      - ses-2
        - beh
          - [Task files collected at follow-up]
    - phenotype
      - [redcap .tsv files]


### bids/rawdata

This folder contains "raw" task and MRI data that has been minimally processed from [bids/sourcedata/](#bidssourcedata) to comply with BIDS standards. When publically sharing task and MRI data, this is the data that gets shared. Similar to bids/sourcedata/, bids/rawdata/ is organized by subject and session. However, subdirectories will differ by modality: MRI data is stored in fmap/, func/, and anat/. Task data is stored in func/ if it was collected alongside fMRI data and beh/ if it was not.

Meta-data for files in bids/rawdata are stored in corresponding JSON files. For MRI data (i.e., nii.gz files), JSONS are subject specific, so they are stored in subject folders alongside the MRI data. For task data (i.e., TSV files), JSONS are stored directly in rawdata/ and apply to all corresponding files in subject and session directories.

This looks like: 
- bids
  - rawdata/
    - [Behavioral task meta-data JSONS]
    - sub-{label}/
      - ses-1/
        - fmap/
          - [Field map MRI data - these end with *.nii.gz]
          - [Field map meta-data JSON files]
        - func/
          - [fMRI data for Food View Task and SST - these end with *.nii.gz]
          - [fMRI meta-data JSON files]
          - [Behavioral data for Food View task and fMRI SST - these end with *_events.tsv]
        - anat/
          - [Structural MRI data - these end with *.nii.gz]
          - [Structural MRI meta-data JSON file]
        - beh/
          - [Behavioral data for tasks *not* collected alongside fMRI data - these end with *_beh.tsv]
      - ses-2/
        - beh/
          - [Behavioral data for tasks *not* collected alongside fMRI data - these end with *_beh.tsv]

Remember, MRI data (i.e., nii.gz files) will only exist on Roar Collab due to size. Task data (i.e., TSV files) can be synced between OneDrive and Roar Collab. 

### bids/phenotype

This folder contains questionnaire, intake, anthropometrics, and dexa data stored in .tsv files. Data for each survey is saved in its own file. TSVs contain raw data, and can also contain derivative data (e.g., questionnaire scores, computed variables). Each data file is accompanied by a JSON meta-data file.

For example:

- bids
  - phenotype
    - {survey-name}.tsv
    - {survey-name}.json


### bids/derivatives

This folder contains datasets that have been processed or derived from data in [bids/rawdata/](#bidsrawdata). The following derivative datasets have been created:

- bids
  - derivatives
    - mriqc
      - [Quality assessment files generated by mriqc]
    - preprocessed/fmriprep_v2401
      - [Preprocessed fmri data, output of fmriprep version 24.0.1]
    - beh
      - [TSV files with summary metrics for each behavioral task]



### bids/code


## Data Processing Software

### R01_Marketing
* [https://github.com/bfuchs18/R01_Marketing](https://github.com/bfuchs18/R01_Marketing)
* This github repository contains a collection of scripts developed to processess and analyze REACH data. The scripts in this repositiory use the software outlined below. 



### dataREACHr
* [https://github.com/bfuchs18/dataREACHr](https://github.com/bfuchs18/dataREACHr)
* This is an R package that contains functions to process and organize survey and task data into bids/phenotype and bids/rawdata, respectively.
    * Use of this package requires the directory structure described [here](#directory-organization)

  * dataREACHr can be installed from github in R using the devtools package:
```r
devtools::install_github("bfuchs18/datareachr")
```


### dataprepr

* [https://github.com/alainapearce/dataprepr](https://github.com/alainapearce/dataprepr)
* This is an R package that contains functions to score a variety of validated questionnaires
  * This is a dependecy of [dataREACHr](#datareachr)
  * Dataprepr can be installed from github in R using the devtools package:

```r
devtools::install_github("alainapearce/dataprepr")
```

### dcm2bids
*  [https://unfmontreal.github.io/Dcm2Bids/3.1.1/](https://unfmontreal.github.io/Dcm2Bids/3.1.1/)
*  This is a program that reorganises NIfTI files into the Brain Imaging Data Structure (BIDS).
*  Data processing scripts expect dcm2bids to be loaded via a conda environment described in /bids/code/dcm2bids/dcm2bids.yml. 

The conda env can be created from the yml file by running the following commands in a Bash terminal on Roar Collab
```bash
# if conda has not been initialized, may need to run this first and then close and reopen terminal
conda init bash 

# Navigate to yml file
cd /storage/group/klk37/default/R01_Marketing/bids/code/dcm2bids/

# Load anaconda
module load anaconda

# Create a conda environment based on yml file
## Note, this will create the conda env in a user-specific directory, so every user has to create their own environemnt
conda env create -f dcm2bids.yml

# activate enviroment
conda activate dcm2bids
```


### pydeface
*  [https://github.com/poldracklab/pydeface](https://github.com/poldracklab/pydeface)
*  This is a tool to remove facial structure from (i.e., "deface") MRI images. 
*  Data processing scripts expect pydeface to be loaded via a conda environment described in /bids/code/dcm2bids/dcm2bids.yml. See the [dcm2bids](#dcm2bids) section for details on how to create the conda environment.

### mriqc
* [https://mriqc.readthedocs.io/en/stable/index.html](https://mriqc.readthedocs.io/en/stable/index.html)
* MRIQC extracts no-reference IQMs (image quality metrics) from structural (T1w and T2w) and functional MRI (magnetic resonance imaging) data. 

A container with MRIQC version 24.0.0 was built by running the following command in a Bash terminal on Roar Collab
```bash
singularity build /storage/group/klk37/default/sw/mriqc-24.0.0.simg  docker://nipreps/mriqc:24.0.0
```

### fmriprep
* [https://fmriprep.org/en/stable/outputs.html](https://fmriprep.org/en/stable/outputs.html)
* fMRIprep is a preprocessing software for MRI data
* On Roar Collab, fMRIprep version 24.0.1 is available in a Singularity Container within /storage/group/klk37/default/sw/fmriprep-23.2.0.simg. By using this singularity container, we can use a version of fMRIprep that is not presently available to all users of Roar Collab.

The container was created by running the following command in a Bash terminal on Roar Collab
```bash
singularity build /storage/group/klk37/default/sw/fmriprep-24.0.1.simg docker://nipreps/fmriprep:24.0.1
```

* Version 24.0.1 was selected for processing because it is (or was) the most recent version available. To use other versions, build another singularity container by specifying a different version number in the command above

### afni
* On Roar Collab, AFNI version 24.2.01 is available in a Singularity Container within /storage/group/klk37/default/sw/afni-24.2.01.simg. By using this singularity container, we can use a version of AFNI that is not presently available to all users of Roar Collab.

The container was created by running the following command in a Bash terminal on Roar Collab
```bash
# If 24.2.01 is the latest version available (check tags to see AFNIs latest push: https://hub.docker.com/r/afni/afni_make_build/tags), can use this command:
singularity pull afni-24.2.01.simg docker://afni/afni_make_build

# pull version 24.2.01
singularity pull afni-24.2.01.simg docker://afni/afni_make_build:AFNI_24.2.01

```


## Data Processing Pipeline

### Overview
Here, data processing refers to the steps required to get data from its source into [bids/phenotype](#bidsphenotype) and [bids/rawdata](#bidsrawdata). 

Broadly, this involves:
1. Retrieving data from the source
   1. This typically involves manual transfer of data onto OneDrive or RoarCollab
2. Running processing scripts

While survey and task data could be processed on OneDrive or Roar Collab, the pipeline outlined below involves processing survey and task data "locally" (i.e., from one's own computer with synced OneDrive files) and then syncing processed data with Roar Collab. MRI data is processed on Roar Collab. 

<img src="./images/REACH_processing_pipeline.png" alt="drawing" width="600"/> 
Figure X. Data procesing pipeline

### Required access
Implementing the described pipeline will require access to projects/folders in:
- REDCap (online data collection software)
- OneDrive (Microsoft's cloud storage service used by Penn State)
- Hoth (server where SLEIC uploads imaging data)
- Roar Collab (Penn State's High Performance Computing Cluster)

Steps to aquire access are outlined in Table X.

Table X. Access required for data processing
<div style="font-size: 12px;">

| Server | Project/Folder | Getting Server Access | Getting project/folder access | Required To... |
| -------- | ------- | ------- | ------- | ------- |
| REDCap | 'Food Marketing Resilience/Project REACH' and 'REACH Data Double Entry' projects | Go to https://ctsi.psu.edu/research-support/redcap/ and select "REQUEST REDCAP ACCESS (NEW USERS"; Requires REDCap training | ask Kathleen Keller (klk37@psu.edu) to grant access | retrieve Survey data from source |
| OneDrive |  b-childfoodlab_Shared/ | ?? | ask Kathleen Keller (klk37@psu.edu) to grant access | store task and survey data in shared location |
| Hoth |  /nfs/imaging-data/3Tusers/klk37/mrkt/ | email	l-sleic-helpdesk@lists.psu.edu and request access, cc Kathleen Keller (klk37@psu.edu)  | email	l-sleic-helpdesk@lists.psu.edu and request access, cc Kathleen Keller (klk37@psu.edu) | retrieve MRI data from source |
| Roar Collab |  storage/group/klk37/ | follow instructions at https://www.icds.psu.edu/account-setup/  | email iask@ics.psu.edu and request access, cc Kathleen Keller (klk37@psu.edu) | store MRI data in shared location; process MRI data; sync task and survey data from OneDrive |

<div style="font-size: 16px;">

### Retriving data from the source

#### Survey (redcap) data

To transfer survey data from source (REDCap) to OneDrive:
   1. Log in to redcap
   2. Download visit data
      1. Navigate to the REDCap project: Food Marketing Resilience/Project REACH
      2. Select 'Data Exports, Reports, and Stats'
      3. Select 'Export data' for the Report Name '**All data** (all records and fields)'
      4. Choose export format: 'CSV/Microsoft Excel (raw data)'
      5. Select export then click icon to download
      6. Transfer file to OneDrive Folder: b-childfoodlab_Shared/Active_Studies/MarketingResilienceRO1_8242020/ParticipantData/bids/sourcedata/phenotype
   3. Download double-entry data
      1. Navigate to the REDCap project: REACH Data Double Entry
      2. Select 'Data Exports, Reports, and Stats'
      3. Select 'Export data' for the Report Name '**All data** (all records and fields)'
      4. Choose export format: 'CSV/Microsoft Excel (raw data)'
      5. Select export then click icon to download
      6. Transfer file to OneDrive Folder: b-childfoodlab_Shared/Active_Studies/MarketingResilienceRO1_8242020/ParticipantData/bids/sourcedata/phenotype

#### Task data

To copy task data from its source to OneDrive:
   1. Locate task data at the source
      1. This location is task-specfic; it is typically on the computer used to administer the task (Table X)
   2. Copy data onto OneDrive into the task-specific folder in [untouchedRaw/](#untouchedraw) (i.e., b-childfoodlab_Shared/Active_Studies/MarketingResilienceRO1_8242020/ParticipantData/untouchedRaw/)
      1. This should happen as soon as possible after data is collected. 
         1. Unlike OneDrive, the computers used for task data collection are not permanent storage locations and are not backed up. 
         2. Do not delete the data from the source. It can remain in that location as a backup until computer resources require files to be removed.
   3. If needed, rename the file in untouchedRaw to adhere to the expected file naming convention (Table X),
  
Table X. Copying Task Data to untouchedRaw
<div style="font-size: 12px;">

| Task    | Data to tranfer | Where data is initially exported | Folder in untouchedRaw | untouchedRaw Naming Convenction |
| ------ | ------ | ------ | ------ | ----- |
| Reinforcing Value of Food Task | `game.csv` <br> `summary.csv` <br> `REACH_{ID}.txt`| On the laptop used for administation in XXX | rrv_task/REACH_{ID} | `rrv_{ID}_game.csv` <br> `rrv_{ID}_summary.csv` <br> `rrv_{ID}.txt` 
| Stop Signal Task | `stop_onsets-{ID}.txt` <br> `stop-{ID}.txt` | On the laptop used for administation in XX| sst | `stop_onsets-{ID}.txt` <br> `stop-{ID}.txt`
| Food View Task | `foodview_onsets-{ID}.txt` <br> `foodview-{ID}.txt` | On the laptop used for administation in XX | foodview_task | `foodview_onsets-{ID}.txt` <br> `foodview-{ID}.txt`
| NIH Toolbox | `{Date} Assessment Data.csv` <br> `{Date} Assessment Scores.csv`  <br> `{Date} Registration Data.csv` | | nih-toolbox |
| Space Game | | |  space_game |
| Pavlovian-to-Intrumental Transfer Task | | On the laptop used for administration in: C:\Project REACH\PIT_Task\Food_PIT| pit_task |

<div style="font-size: 16px;">

#### MRI data
To copy MRI data from its source (Hoth) to Roar Collab:

[Add these details]

### MRI data processing example for subject 001

Process and organize MRI task data locally in R (requires having OneDrive synced):\
Note: events.tsv files are required for fmriprep, so this must be done before running fmriprep
- dataREACHr::proc_task()
- generate bids/rawdata/*/func/*events.tsv files 


To process and organize MRI data on Roar Collab, enter the following commands into a Bash or tcsh terminal:
```bash
### copy data from Hoth to untouchedRaw/ on RoarCollab ###


### copy data from untouchedRaw/ into bids/sourcedata/ ###

# naviagate to directory with script
cd /storage/group/klk37/default/R01_Marketing/bids/code/dcm2bids

# run shell script for sub 001
./1_pre-dcm2bids.tsch 001

### Manual inspection and labeling of extra scans in sourcedata ###

### Organize MRI data into BIDS (bids/rawdata/) ###

# naviagate to directory with script
cd /storage/group/klk37/default/R01_Marketing/bids/code/dcm2bids

# activate dcm2bids conda env
conda activate dcm2bids

# run shell script for sub 001
./2_dcm2bids.tsch 001

```

### Explanation of MRI data processing steps


### Organizing data into BIDS with processing scripts

#### Survey and Task Data

Survey and task data are processed and organized into BIDS using the script [beh_into_bids.R](https://github.com/bfuchs18/R01_Marketing/blob/master/ParticipantData/bids/code/beh_into_bids.R) which is shared in the [R01_Marketing GitHub Repository](##r01_marketing).

beh_into_bids.R was written to process files stored in OneDrive, provided they are synced to a local computer and the script is run locally. After processing data locally, beh_into_bids.R syncs data to Roar Collab.

Therefore, running beh_into_bids.R requires:
1. That [R](#r) is installed
2. That the R package [dataREACHr](#datareachr) its dependencies, including [dataprepr](#dataprepr), are installed. Details about installing dataREACHr and dataprepr can be found [here](#data-processing-software).
3. That the user has OneDrive files synced to their computer
4. That the script correctly specifies (1) the path to ParticipantData on OneDrive, (2) the names of REDCap files in sourcedata, and (3) the PSU user ID. To specify this information, modify the following lines of code in beh_into_bids.R:
```r
#### user setup (modify variables here) ####

# set path to ParticipantData directory on OneDrive (contains bids/ and untouchedRaw/)
base_dir = "/Users/baf44/Library/CloudStorage/OneDrive-ThePennsylvaniaStateUniversity/b-childfoodlab_Shared/Active_Studies/MarketingResilienceRO1_8242020/ParticipantData/"

# set redcap file names
visit_file_name =  "FoodMarketingResilie_DATA_2024-05-03_1132.csv"
double_entry_file_name = "REACHDataDoubleEntry_DATA_2024-04-08_1306.csv"

# Penn State user ID
## needed for syncing data between OneDrive and Roar Collab
user_id = "baf44"

```

Overview of beh_into_bids.R:

- Survey data is processed using dataREACHr::proc_redcap(). This function:
  * Imports visit and double-entry data downloaded from redcap
  * Calls dataREACHr and dataprepr functions to extract, process, and score data
  * Exports participants.tsv data files and participants.json meta-data files into [bids/](#bids).
  * Exports {survey}.tsv data files and {survey}.json meta-data files into [bids/phenotype/](#bidsphenotype).
- Task data is processed using dataREACHr::proc_task(). This function:
  * Copies task data from [bids/untouchedRaw](#untouchedraw) into [bids/sourcedata/](#bidssourcedata)
    * This is done with util_org_sourcedata(), which presently copies data for: food view task, stop signal task
  * Processes and exports task data into [bids/rawdata/](#bidsrawdata) for:
    * food view task (using util_task_foodview())
    * SST (using util_task_sst())
  * Exports a meta-data JSON file into bids/rawdata for the following tasks: foodview_bold, sst_bold, sst_beh
    * Done using write_task_jsons()
- Survey and Task data in untouchedRaw/ and bids/ on OneDrive (local) are synced to Roar Collab using rsync

### Neuroimaging data

#### Example processing for sub 001
Following these steps requires that data have already copied from Hoth to Roar Collab

SSH into Roar Collab
```
ssh
```
From Roar Collab, run data processing shell scripts
```bash
### 1. copy data from untouchedRaw/ into bids/sourcedata/ ###

# naviagate to directory with script
cd /storage/group/klk37/default/R01_Marketing/bids/code/dcm2bids

# run shell script for sub 001
./1_pre-dcm2bids.tsch 001

### 2. Manual steps ###

#### label extra scans in sourcedata/
#### add names of fieldmaps to fmap_descriptions.csv

### 3. Organize MRI data into BIDS (bids/rawdata/) ###

# naviagate to directory with script
cd /storage/group/klk37/default/R01_Marketing/bids/code/dcm2bids

# activate dcm2bids conda env
conda activate dcm2bids

# run shell script for sub 001
./2_dcm2bids.tsch 001

```


## Data Quality Control

#### Survey data
To increase quality of survey data:

1. Merged double-entered records are processed for the following measures: DEXA, intake (pre and post weights), WASI, fullness ratings, CAMS
   1. Data-double entry process: (1) 2 researchers enter the data into REDCap, (2) discrepencies between double-entered records are resolved by a reviwer, (3) records are merged when they match
2. The function dataREACHr::qc_redcap() checks for:
   1. Duplicate data (e.g., multiple rows for a given subject/session combination) in processed phenotype databases
   2. Child visit 1 ages out of expected range (7-9)
      1. This would suggest a mis-entry of child birthdate (by parent in [V1 demographics form](#visit-1-demographics)) or visit 1 protocol date (by researcher)
         1. If a parent mis-entered their child's birthdate in the V1 demographics form (e.g., entered the year of the study visit rather than child birth), the child birthdate in the V1 demographics form was updated by a researcher with the child birthdate provided by the parent during screening
   3. Negative consumption amounts??

#### MRI data



## Data Documentation

details on codebook (need to make) and variable descriptions (.jsons)

## Pre-Processing Pipeline

narative overview with steps...  
image of pipeline  


### Pipeline Execution

#### 1) Raw Data

##### 1a) Exporting

##### 1b) Quality Control

#### 2) ...

# Interactive Reports and Tables

description or reports through .Rmd

# Analyses: Guidelines for Reproducibility and Documentation

