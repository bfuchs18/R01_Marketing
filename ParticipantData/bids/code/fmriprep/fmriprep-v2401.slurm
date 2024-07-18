#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=10
#SBATCH --mem-per-cpu=20GB
#SBATCH --time=24:00:00
#SBATCH --partition=open
#SBATCH --output=slurm_fmriprep_%a.out
#SBATCH --array=1-94
#
# Useage: 
### Option A: run fmriprep for all subjects in rawdata_dir: sbatch fmriprep_v2401.slurm
### Option B: use input args to specify subjects (can specify 1 or more)
###                  e.g., sbatch fmriprep_v2401.slurm 001 002 003 
###                  e.g., sbatch fmriprep_v2401.slurm 132 

# Get started
echo "Job started on `hostname` at `date`"

# Set directories
singularity_dir="/storage/group/klk37/default/sw"
bids_root_dir="/storage/group/klk37/default/R01_Marketing/bids"
code_dir="$bids_root_dir/code/fmriprep/"

# Define list of subjects to process

# if no IDs provided as input
if [ "$#" -eq 0 ]; then

    # Create an array to store the subs to process
    subs=()

    # Loop through subfolders in rawdata_dir that with begin with sub-
    for folder in "$rawdata_dir"sub-*; do

        # Extract the string following "sub-" and add it to the array subs
        sub=$(basename "$folder" | sed 's/sub-//')
        subs+=("$sub")

    done

# if IDs provided as input
else 
    # assign input args to subs 
    subs=("$@")
fi

# Get the index of the current task
index=$(($SLURM_ARRAY_TASK_ID - 1))

# Get the participant ID for the current task
subj=${subs[$index]}

# echo script contents into slurm output
echo "sub-${subj} fmriprep_v2401.slurm script"
echo "--------- start of slurm script ---------"
cat "$0"
echo
echo "--------- end of slurm script ---------------"
echo

# Check if subj is blank or out of bounds
if [ -z "$subj" ]; then
    echo "Empty participant ID at index $index."
else

    # check if output already exists
    shopt -s nullglob # Enable nullglob to handle the case where no files match - otherwise, files will contain the non-expanded file sub-${subj}*.html
    files=($bids_root_dir/derivatives/preprocessed/fmriprep_v2401/sub-${subj}*.html)

    # if number of html files is greater than 0
    if [ ${#files[@]} -gt 0 ]; then
        echo "fmriprep html file exist. Delete to rerun"
    else 
	
        #Run MRIQC
        echo ""
        echo "Running fmriprep on sub-${subj}"
        echo ""

		# freesurfer setup
		export FREESURFER_HOME=/storage/group/klk37/default/sw/freesurfer/7.3.2
		source $FREESURFER_HOME/SetUpFreeSurfer.sh
		export FS_LICENSE=/storage/group/klk37/default/sw/freesurfer/license.txt

		# Go to the correct location
		cd $PBS_O_WORKDIR

		# Run the job itself
		unset PYTHONPATH; singularity run --cleanenv $singularity_dir/fmriprep-24.0.1.simg \
			$bids_root_dir/rawdata $bids_root_dir/derivatives/preprocessed/fmriprep_v2401 \
			participant \
			--participant_label $subj \
			--verbose \
			--output-spaces MNI152NLin2009cAsym:res-native \
			--fs-license-file $FS_LICENSE \
			--work-dir $bids_root_dir/code/fmriprep/sub-$subj/work_v2401
    fi
fi

# Rename the default SLURM output file to custom output file
output_file="$code_dir/fmriprep-v2401_sub-${subj}.out"
mv $code_dir/slurm_fmriprep_${SLURM_ARRAY_TASK_ID}.out $output_file

# Finish up
date=$(date +"%Y-%m-%d")
echo "Job Ended at `date`"