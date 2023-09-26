#!/bin/bash
#SBATCH --job-name=test1
#SBATCH --nodes=1
#SBATCH -e /EDISON2/home/user/jobs/1/std.err
#SBATCH -o /EDISON2/home/user/jobs/1/std.out
#SBATCH --partition=basic
#SBATCH --ntasks=1
#SBATCH --nodes=1

export PROGRAM_HOME=/EDISON2/solvers/semi/qe_demo/1.0.0

python3 /EDISON2/solvers/semi/qe_demo/1.0.0/script_modeling.py --inp /EDISON2/solvers/semi/qe_demo/1.0.0/inputs/input.toml --xsf /EDISON2/solvers/qe_demo/1.0.0/inputs/input.xsf

pw.x < simulation_1.txt 
pw.x < simulation_2.txt 
bands.x < simulation_3.txt