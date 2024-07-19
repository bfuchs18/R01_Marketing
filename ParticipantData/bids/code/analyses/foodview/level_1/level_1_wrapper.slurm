#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=10
#SBATCH --mem-per-cpu=5GB
#SBATCH --time=4:00:00
#SBATCH --partition=open
#SBATCH --output=slurm_lev1_%a.out
#SBATCH --array=1-94
#
# Useage: 
### Option A: run level_1_wrapper for all subjects in fmriprep: sbatch level_1_wrapper.slurm
### Option B: use input args to specify subjects (can specify 1 or more)
###                  e.g., sbatch level_1_wrapper.slurm 001 002 003 
###                  e.g., sbatch level_1_wrapper.slurm 132 

# Get started
echo "Job started on `hostname` at `date`"


###################
# Set directories # 
###################

bids_dir="/storage/group/klk37/default/R01_Marketing/bids/"
code_dir="$bids_dir/code/analyses/foodview/level_1/"
fmriprep_dir="$bids_dir/derivatives/preprocessed/fmriprep_v2401/"
analysis_dir="$bids_dir/derivatives/analyses/foodview/"
singularity_dir="/storage/group/klk37/default/sw/"

##################################
# Define list of subs to process # 
##################################

# if no IDs provided as input
if [ "$#" -eq 0 ]; then

    # Create an array to store the subs to process
    subs=()

    # Loop through subfolders in rawdata_dir that with begin with sub-
    for folder in "$fmriprep_dir"sub-*; do

        # Extract the string following "sub-" and add it to the array subs
        sub=$(basename "$folder" | sed 's/sub-//')
        subs+=("$sub")

    done

# if IDs provided as input
else 
    # assign input args to subs 
    subs=("$@")
fi

#########################################
# Call processing scripts for given sub # 
#########################################

# Get the index of the current task
index=$(($SLURM_ARRAY_TASK_ID - 1))

# Get the participant ID for the current task
sub=${subs[$index]}

# echo script contents into slurm output
echo "sub-${sub} level_1_wrapper.slurm script"
echo "--------- start of slurm script ---------"
cat "$0"
echo
echo "--------- end of slurm script ---------------"
echo

# Check if sub is blank or out of bounds
if [ -z "$sub" ]; then
    echo "Empty participant ID at index $index."
else

    # Run python wrapper
    module load anaconda
    conda activate pandas
    python3 $code_dir/proc_functions/wrapper-python.py -s $sub -d $bids_dir 

    # Run afniproc
    singularity exec $singularity_dir/afni-23.1.10.simg bash $code_dir/proc_functions/afni_proc.sh $sub $fmriprep_dir $analysis_dir


fi

# Rename the default SLURM output file to custom output file
output_file="$code_dir/lev1_sub-${sub}.out"
mv $code_dir/slurm_lev1_${SLURM_ARRAY_TASK_ID}.out $output_file

# Finish up
date=$(date +"%Y-%m-%d")
echo "Job Ended at `date`"