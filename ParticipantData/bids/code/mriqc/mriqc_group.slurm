#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=10
#SBATCH --mem-per-cpu=10GB
#SBATCH --time=4:00:00
#SBATCH --partition=open
#SBATCH --output=%x.%j.out

#User inputs:
bids_root_dir="/storage/group/klk37/default/R01_Marketing/bids/"
rawdata_dir="$bids_root_dir/rawdata/"
singularity_dir="/storage/group/klk37/default/sw/"

# echo script contents into slurm output
echo "MRIQC Group SLURM script"
echo "--------------------"
cat "$0"
echo "--------------------"

#Run MRIQC
echo ""
echo "Running MRIQC on group"
echo ""

unset PYTHONPATH; singularity run --cleanenv $singularity_dir/mriqc-24.0.0.simg \
    $rawdata_dir $bids_root_dir/derivatives/mriqc/ participant \
    --float32 \
    --mem_gb 20 \
    --n_procs 10 \
    --omp-nthreads 10
