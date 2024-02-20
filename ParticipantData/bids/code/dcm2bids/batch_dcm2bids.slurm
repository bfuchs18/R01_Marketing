#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=5
#SBATCH --mem-per-cpu=10GB
#SBATCH --time=2:00:00
#SBATCH --account=klk37
#SBATCH --partition=sla-prio 
#SBATCH --output=%x.%j
#
#Useage: sbatch proc_paper1-subs.slurm
#
#

######## Set up inital variables ########

# activate dcm2bids
module load anaconda
source activate dcm2bids

# load fsl
module load fsl

#date
today=`date +%m-%d-%y`

#set sourcedata_path directory
sourcedata_path="/storage/group/klk37/default/R01_Marketing/bids/sourcedata/"

# Create an array to store the subs to process
subs=()

# Loop through subfolders in sourcedata_path with begin with sub-
for folder in "$sourcedata_path"sub-*; do
    # Extract the string following "sub-" and add it to the array subs
    sub=$(basename "$folder" | sed 's/sub-//')
    subs+=("$sub")
done

# loop through subs

# for testing
#subs=( "003" ) 

for sub in "${subs[@]}"; do

	#write to output file
	echo "## sub_${sub} 2_dcm2bids was run on ${today}"
	echo "## Job started: `date`"

	#run script
	tcsh 2_dcm2bids.tcsh ${sub}

done
