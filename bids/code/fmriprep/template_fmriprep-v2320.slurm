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

# freesurfer setup
export FREESURFER_HOME=/storage/group/klk37/default/sw/freesurfer/7.3.2
source $FREESURFER_HOME/SetUpFreeSurfer.sh
export FS_LICENSE=/storage/group/klk37/default/sw/freesurfer/license.txt

# Go to the correct location
cd $PBS_O_WORKDIR

# Set directories
singularity_dir="/storage/group/klk37/default/sw"
bids_root_dir="/storage/group/klk37/default/R01_Marketing/bids"

# Run the job itself
unset PYTHONPATH

# Note: as of 2/20/24, fmriprep 23.2.0 has a bug preventing the selection of cohorts with MNIPediatricAsym (which is needed to use MNIPediatricAsym). 
# see: https://github.com/nipreps/smriprep/issues/407. Therefore, data will be preprocessed using output-space MNI152NLin2009cAsym (fMRIprep default)

singularity run --cleanenv $singularity_dir/fmriprep-23.2.0.simg \
	$bids_root_dir/raw_data $bids_root_dir/derivatives/preprocessed/fmriprep_v2320 \
	participant \
	--participant_label PARNUM \
	--verbose \
	--output-spaces MNI152NLin2009cAsym:res-native \
	--fs-license-file $FS_LICENSE \
	--work-dir $bids_root_dir/code/fmriprep/sub-PARNUM/work_v2320

# Finish up
echo "Job Ended at `date`"