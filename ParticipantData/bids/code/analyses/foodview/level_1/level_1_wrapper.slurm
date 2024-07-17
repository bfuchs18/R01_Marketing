#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem-per-cpu=10GB
#SBATCH --time=4:00:00
#SBATCH --partition=open
#
# Useage: 
### Option A: run wrapper for all subjects in rawdata_dir: sbatch proc_wrapper.slurm
### Option B: use input args to specify subjects to run for (can specify 1 or more)
###                  e.g., sbatch proc_wrapper.slurm 001 002 003 
###                  e.g., sbatch proc_wrapper.slurm 132 

###############
# User inputs # 
###############
sub=1
bids_dir="/storage/group/klk37/default/R01_Marketing/bids/"

#################################################
# Call python and AFNI data processign wrappers # 
#################################################

# Define paths
code_dir="$bids_dir/code/analyses/foodview/"
analysis_dir="$bids_dir/derivatives/analyses/foodview/"
singularity_dir="/storage/group/klk37/default/sw/"

# Call python wrapper
module load anaconda
conda activate pandas
python3 $code_dir/level_1/proc_functions/wrapper-python.py -s $sub -d $bids_dir

# Call AFNI wrapper
