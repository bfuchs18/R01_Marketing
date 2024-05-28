#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=10
#SBATCH --mem-per-cpu=10GB
#SBATCH --time=4:00:00
#SBATCH --partition=open
#SBATCH --output=slurm_mriqc_%a.out
#SBATCH --array=1-94
#
# Useage: 
### Option A: run mriqc for all subjects in rawdata_dir: sbatch mriqc_participants.slurm
### Option B: use input args to specify subjects to run mriqc for (can specify 1 or more)
###                  e.g., sbatch mriqc_participant.slurm 001 002 003 
###                  e.g., sbatch mriqc_participant.slurm 132 


#User inputs:
bids_root_dir="/storage/group/klk37/default/R01_Marketing/bids/"
rawdata_dir="$bids_root_dir/rawdata/"
singularity_dir="/storage/group/klk37/default/sw/"
mriqc_code_dir="$bids_root_dir/code/mriqc/"

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
echo "Subject ${subj}"
echo "SLURM script"
echo "--------------------"
cat "$0"
echo "--------------------"

# Check if subj is blank or out of bounds
if [ -z "$subj" ]; then
    echo "Empty participant ID at index $index."
else

    # check if output already exists
    shopt -s nullglob # Enable nullglob to handle the case where no files match - otherwise, files will contain the non-expanded file sub-${subj}*.html
    files=($bids_root_dir/derivatives/mriqc/sub-${subj}*.html)

    # if number of html files is greater than 0
    if [ ${#files[@]} -gt 0 ]; then
        echo "MRIQC html files exist. Delete to rerun"
    else 
        #Run MRIQC
        echo ""
        echo "Running MRIQC on participant ${subj}"
        echo ""

        unset PYTHONPATH; singularity run --cleanenv $singularity_dir/mriqc-24.0.0.simg \
        $rawdata_dir $bids_root_dir/derivatives/mriqc/ participant \
        --participant-label ${subj} \
        --fd_thres .9 \
        --float32 \
        --mem_gb 20 \
        --n_procs 10 \
        --omp-nthreads 10
    fi
fi

# Rename the default SLURM output file to custom output file
date=$(date +"%Y-%m-%d")
output_file="$mriqc_code_dir/mriqc_${subj}_${date}.out"
mv $mriqc_code_dir/slurm_mriqc_${SLURM_ARRAY_TASK_ID}.out $output_file

