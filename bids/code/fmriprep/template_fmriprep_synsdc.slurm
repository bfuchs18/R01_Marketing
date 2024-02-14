#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=10
#SBATCH --mem-per-cpu=20GB
#SBATCH --time=24:00:00
#SBATCH --partition=open
#SBATCH --output=%x.%j

#Usage: sbatch sub-PARNUM_fmriprep.slurm

# Get started
echo "Job started on `hostname` at `date`"

# load fmriprep from Roar Collab software stack
echo "Clearing environment and loading fmriprep"
module purge
module load fmriprep/23.1.0
echo "Done!"

# freesurfer setup
export FREESURFER_HOME=/storage/group/klk37/default/sw/freesurfer/7.3.2
source $FREESURFER_HOME/SetUpFreeSurfer.sh
export FS_LICENSE=/storage/group/klk37/default/sw/freesurfer/license.txt

# Go to the correct location
cd $PBS_O_WORKDIR

# Set bids directory
bids_root_dir="/storage/group/klk37/default/R01_Marketing/bids"

# Run the job itself
unset PYTHONPATH
fmriprep $bids_root_dir/raw_data $bids_root_dir/derivatives/preprocessed/fmriprep_synsdc \
	participant \
	--participant_label PARNUM \
	--verbose \
	--use-syn-sdc \
    --ignore fieldmaps \
	--output-spaces MNIPediatricAsym:res-1:cohort-3 \
	--fs-license-file $FS_LICENSE \
	--work-dir $bids_root_dir/code/fmriprep/sub-PARNUM/work_synsdc

# Finish up
echo "Job Ended at `date`"