#!/bin/bash

#SBATCH -a 1-10
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
#SBATCH --partition=xeon-p8
#SBATCH --time=0-00:10
#SBATCH -o /home/aschmid/mydir/outerr/run_\%a.out
#SBATCH -e /home/aschmid/mydir/outerr/run_\%a.err

#Load software
module load julia/1.7.3

#Run the script as usual
julia shortestpath_many.jl $SLURM_ARRAY_TASK_ID
