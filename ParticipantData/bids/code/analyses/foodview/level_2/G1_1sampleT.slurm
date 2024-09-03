#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem-per-cpu=20GB
#SBATCH --time=2:00:00
#SBATCH --partition=open
#SBATCH --output=%x.%j
#
#Useage: sbatch G1_1sampleT.slurm
#
#
######## Set up inital variables ########

#don't log AFNI programs in ~/.afni.log
AFNI_DONT_LOGFILE="YES"

#dont try version checks
ANFI_VRSION_CHECK="NO"

##don't auto-compress output files
AFNI_COMPRESSOR="NONE"

#set number of processors for AFNI to match the number of cores
# see https://afni.nimh.nih.gov/pub/dist/doc/program_help/3dTfitter.html
OMP_NUM_THREADS="10"

#date
today=`date +%m-%d-%y`

#set directories
bids_dir="/storage/group/klk37/default/R01_Marketing/bids/"
singularity_dir="/storage/group/klk37/default/sw/"
code_dir="$bids_dir/code/analyses/foodview/level_2/"

#write to output file
echo "## G1_1sampleT was run on ${today}"
echo "## Job started: `date`"

#Load afni singularity and run afniscript
singularity exec $singularity_dir/afni-24.2.01.simg tcsh $code_dir/G1_1sampleT.sh
singularity exec $singularity_dir/afni-24.2.01.simg tcsh $code_dir/G1_1sampleT_reml.sh