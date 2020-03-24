#!/bin/bash
# regularInteractive on graham
# neurogliaMincShell (/project/6007967/akhanf/singularity/khanlab-prepT2space-master-v0.0.2b.simg)

script_dir=~/GitHub/snsx32/scripts/template_building/snsx32_qmaps/snsx32_qmaps_v0.2_i09/
csv_full_path=~/GitHub/snsx32/input/input_csv/snsx32.csv
output_log_dir=~/project/snsx32/qmaps/snsx32_qmaps_v0.2_i09/logs/

mkdir -p $output_log_dir

# T1w+T1map+R1map template creation
echo $script_dir/snsx32_qmaps_v0.2_i09_T1w.sh -i $csv_full_path
$script_dir/snsx32_qmaps_v0.2_i09_T1w.sh -i $csv_full_path  >& $output_log_dir/snsx32_qmaps_v0.2_i09_T1w.log
echo $script_dir/snsx32_qmaps_v0.2_i09_T1map.sh -i $csv_full_path
$script_dir/snsx32_qmaps_v0.2_i09_T1map.sh -i $csv_full_path  >& $output_log_dir/snsx32_qmaps_v0.2_i09_T1map.log

# T2space template creation
#   Note: slightly different from the rest due to the need for manualQC of rigid registration in two cases
echo $script_dir/snsx32_qmaps_v0.2_i09_T2space.sh -i ~/GitHub/snsx32/scripts/template_building/snsx32_qmaps/snsx32_qmaps_v0.2_i09/snsx32_qmaps_T2space_QCed.csv
$script_dir/snsx32_qmaps_v0.2_i09_T2space.sh -i $script_dir/snsx32_qmaps_v0.2_i09_T2space_QCed.csv >& $output_log_dir/snsx32_qmaps_v0.2_i09_T2space.log

