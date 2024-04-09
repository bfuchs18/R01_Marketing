This repo contains code to process data from Keller Lab Marketing Study

- bids/code/dcm2bids: contains code to organize fMRI data into BIDS (https://bids.neuroimaging.io/) format
  - 1_pre-dcm2bids.tcsh: copies DICOMS from untouchedRaw to bids/sourcedata
  - 2_dcm2bids.tcsh: converts DICOMS in sourcedata to bids-formatted .nii in raw_data
  - batch_dcm2bids.slurm: runs 2_dcm2bids.tcsh for all subs in sourcedata on SLURM

- bids/code/beh_into_bids.R: script to process and organize redcap (phenotype) and task data into bids/ using dataREACHr functions (https://github.com/bfuchs18/dataREACHr)
