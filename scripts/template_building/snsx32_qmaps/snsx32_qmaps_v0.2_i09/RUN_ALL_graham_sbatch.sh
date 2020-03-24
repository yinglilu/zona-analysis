#!/bin/bash
#SBATCH --mail-user=jlau287@uwo.ca
#SBATCH --mail-type=ALL
#SBATCH --account=rrg-akhanf
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16gb
#SBATCH --time=24:00:00
#SBATCH -v
~/GitHub/snsx32/scripts/template_building/snsx32_qmaps/snsx32_qmaps_v0.2_i09/RUN_ALL.sh
