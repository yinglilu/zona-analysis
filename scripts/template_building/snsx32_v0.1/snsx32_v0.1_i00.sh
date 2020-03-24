#!/bin/bash
## this script initializing with an affine registration (-r 1); also align with MNI2009b first
#SBATCH --mail-user=jlau287@uwo.ca
#SBATCH --mail-type=ALL
#SBATCH --account=rrg-akhanf
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=32gb
#SBATCH --time=12:00:00
#SBATCH -v
~/GitHub/snsx32/scripts/antsMVTC2/antsMultivariateTemplateConstruction2_graham.sh -d 3 -i 1 -k 1 -f 12x6x4x2x1 -s 6x3x2x1x0vox -q 100x100x70x50x10 -b 1 -t SyN -m CC -c 5 -n 0 -r 1 -u 12:00:00 -v 32gb -y 0 -z ~/templates/MNI2009b_T1.nii.gz -o snsx32_v0.1_i00 ~/GitHub/snsx32/input/input_csv/snsx32_T1w_gradcorrected.csv
