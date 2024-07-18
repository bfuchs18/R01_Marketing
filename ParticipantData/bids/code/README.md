This folder contains code to process data from Keller Lab Marketing Study

-   bids/code/beh_into_bids.R: script to process and organize redcap (phenotype) and task data into bids/rawdata/ using dataREACHr functions (<https://github.com/bfuchs18/dataREACHr>)
-   bids/code/dcm2bids: contains code to organize MRI data into BIDS (<https://bids.neuroimaging.io/>)
    -   1_pre-dcm2bids.tcsh: copies DICOMS from untouchedRaw to bids/sourcedata/ for sub specified in command line arg
    -   2_dcm2bids.tcsh: converts DICOMS in bids/sourcedata to bids-formatted .nii in bids/rawdata for sub specified in command line arg
    -   batch_dcm2bids.slurm: runs 2_dcm2bids.tcsh for all subs in bids/sourcedata/ via SLURM
-   bids/code/mriqc: contains code to run MRIQC on MRI data in /bids/rawdata/ (<https://mriqc.readthedocs.io/en/latest/>)
    -   mriqc_participant.slurm: runs participant-level MRIQC via SLURM for all subs in bids/rawdata/ or those specified in command line args
    -   mriqc_group.slurm: runs group-level MRIQC via SLURM
-   bids/code/fmriprep: contains code to preprocess MRI data with fMRIPrep (<https://fmriprep.org/en/stable/outputs.html>)
    -   fmriprep_v2401.slurm: runs fmriprep 24.0.1 via SLURM for all subs in rawdata/ or those specified in command line args
