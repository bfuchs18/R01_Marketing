This repo contains code to process data from Keller Lab Marketing Study

- bids/code/dcm2bids: contains code to organize MRI data into BIDS (https://bids.neuroimaging.io/) format
  - 1_pre-dcm2bids.tcsh: copies DICOMS from untouchedRaw to bids/sourcedata
  - 2_dcm2bids.tcsh: converts DICOMS in sourcedata to bids-formatted .nii in bids/rawdata
  - batch_dcm2bids.slurm: runs 2_dcm2bids.tcsh for all subs in bids/sourcedata via SLURM

- bids/code/mriqc: contains code to run MRIQC for quality checking raw MRI data that has been organized into BIDS (https://mriqc.readthedocs.io/en/latest/)
  - mriqc_participant.slurm: runs participant-level MRIQC via SLURM
  - mriqc_group.slurm: runs group-level MRIQC via SLURM

- bids/code/fmri: contains code to preprocess MRI data with fMRIPrep (https://fmriprep.org/en/stable/outputs.html)
  - gen_sub_fmriprep.sh: creates subject-specific scripts to run fmriprep
  - template_fmriprep-v2320.slurm: template for subject-specific scripts (used by gen_sub_fmriprep.sh)
 
- bids/code/beh_into_bids.R: script to process and organize redcap (phenotype) and task data into bids/ using dataREACHr functions (https://github.com/bfuchs18/dataREACHr)
