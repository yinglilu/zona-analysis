#!/bin/bash
#SBATCH --account=rrg-akhanf
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32gb
#SBATCH --time=24:00:00
#SBATCH -v
~/GitHub/snsx32/scripts/antsMVTC2/antsMultivariateTemplateConstruction2_graham_8core.sh -d 3 -i 1 -k 1 -f 12x6x4x2x1 -s 6x3x2x1x0vox -q 100x100x70x50x10 -b 1 -t SyN -m CC -c 5 -n 0 -u 24:00:00 -v 16gb -y 0 -z input_template_fullpath.nii.gz -o snsx32_template_name ~/GitHub/snsx32/input/input_csv/snsx32_T1w.csv
