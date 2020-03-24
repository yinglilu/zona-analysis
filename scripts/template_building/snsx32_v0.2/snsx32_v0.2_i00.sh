#!/bin/bash
## no need to initialize with rigid registration; just use template created from v0.1_i09 (10th iteration)
#SBATCH --mail-user=jlau287@uwo.ca
#SBATCH --mail-type=ALL
#SBATCH --account=rrg-akhanf
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16gb
#SBATCH --time=12:00:00
#SBATCH -v
~/GitHub/snsx32/scripts/antsMVTC2/antsMultivariateTemplateConstruction2_graham.sh -d 3 -i 1 -k 2 -f 12x6x4x2x1 -s 6x3x2x1x0vox -q 100x100x70x50x10 -b 1 -t SyN -m CC -c 5 -n 0 -u 12:00:00 -v 64gb -y 0 -z ~/project/snsx32/templates/snsx32_v0.2/initial_templates/snsx32_v0.1_i09_avg_T1w.nii.gz -z ~/project/snsx32/templates/snsx32_v0.2/initial_templates/snsx32_v0.1_i09_avg_T2w.nii.gz -o snsx32_v0.2_i00 ~/GitHub/snsx32/input/input_csv/snsx32_T1w_and_space-T1w_T2w.csv
