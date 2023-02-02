#!/bin/bash

#SBATCH -a 1-5
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
#SBATCH --partition=sched_any_quicktest
#SBATCH --time=0-00:10
#SBATCH -o /home/aschmid/iap_hpc/highthroughput_eng/run_\%a.out
#SBATCH -e /home/aschmid/iap_hpc/highthroughput_eng/run_\%a.err

#Load software
module load julia/1.7.3

#Run the script as usual
julia shortestpath_many.jl $SLURM_ARRAY_TASK_ID
