#!/bin/bash

#Slurm sbatch options
#SBATCH -n 4
#SBATCH --partition=sched_mit_sloan_batch

#Load software
module load julia/1.7.3
module load mpi

#Run the script as usual
mpirun julia shortestpath_mpi.jl
