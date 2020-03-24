#!/bin/bash
# resample preprocessed T2space images (in subject T1w space) into template space
# how to run on graham: regularInteractive --> neurogliaShell --> cd /project/6007967/jclau/snsx32/sandbox/
#   then: ~/GitHub/snsx32/scripts/template_building/snsx32_qmaps/snsx32_qmaps_v0.2_i09/snsx32_qmaps_v0.2_i09_T2space.sh -i ~/GitHub/snsx32/scripts/template_building/snsx32_qmaps/snsx32_qmaps_v0.2_i09/snsx32_qmaps_T2space_QCed.csv

#function for unwarping and generating warp files
function usage {
 echo ""
 echo "Resample preprocessed T2space images (in subject T1w space) into template space"
 echo ""
 echo "Required args:"
 echo "  -i input_csv with subject names (e.g. sub-C020) and links to location of QC'ed T2space files in T1 space"
 echo ""
}

if [ "$#" -lt 2 ]
then
 usage
 exit 1
fi

while getopts "i:" options; do
 case $options in
     i ) echo "  Input csv $OPTARG"
         in_csv=$OPTARG;;

    * ) usage
	exit 1;;
 esac
done

echo "Input CSV file: $in_csv"

# TODO: remove hardcoded paths/variable names
input_dir=/project/6007967/cfmm-bids/Khan/SNSX_7T/derivatives/gradcorrect_0.0.1h/
input_T2_dir=/project/6007967/cfmm-bids/Khan/SNSX_7T/derivatives/gradcorrect_0.0.1h/
output_dir=/project/6007967/jclau/snsx32/qmaps/snsx32_qmaps_v0.2_i09/

# input template
TEMPLATE=snsx32_v0.2_i09
template_dir=/project/6007967/jclau/snsx32/templates/snsx32_v0.2/${TEMPLATE}/
input_template=${template_dir}/${TEMPLATE}template0.nii.gz

# 700iso version
template_700iso=${output_dir}/templates/${TEMPLATE}template0_700iso_T1w.nii.gz

# can use read and IFS=',' to parse multicolumn csvs
# https://stackoverflow.com/questions/13434260/loop-through-csv-file-and-create-new-csv-file-with-while-read
IFS=','
while read SUBJ SUBJ_PATH; do
  echo "---------"
  echo $SUBJ
  echo $SUBJ_PATH
  echo "---------"
  input_T1w=${input_dir}/${SUBJ}/anat/${SUBJ}_acq-MP2RAGE_run-01_T1w.nii.gz
  input_T2prep=${SUBJ_PATH}/${SUBJ}/anat/${SUBJ}_acq-SPACE_proc-prepT2_T2w.nii.gz
  input_T2prep_to_T1w_mat_FSL=${SUBJ_PATH}/${SUBJ}/anat/${SUBJ}_acq-SPACE_proc-prepT2_target-T1w_affine.mat

  output_T2prep_to_T1w_mat_ITK=${output_dir}/work/${SUBJ}/anat/${SUBJ}_acq-SPACE_proc-prepT2_target-T1w_affine_ITK.mat

  output_T2prep=${output_dir}/${SUBJ}/anat/${SUBJ}_acq-SPACE_proc-prepT2_space-template_T2w.nii.gz
  output_T2prep_700iso=${output_dir}/${SUBJ}/anat/${SUBJ}_acq-SPACE_space-template_res-700iso_T2w.nii.gz

  mkdir -p ${output_dir}/${SUBJ}/anat/
  mkdir -p ${output_dir}/work/${SUBJ}/anat/

  searchstring_xfm_warp=*MP2RAGE*T1w*Warp.nii*
  searchstring_xfm_affine=*MP2RAGE*T1w*GenericAffine.mat

  input_xfm_warp=`eval ls ${template_dir}/${TEMPLATE}${SUBJ}${searchstring_xfm_warp} | sort -nr | head -n 1` # just want Warp not InverseWarp
  input_xfm_affine=`eval ls ${template_dir}/${TEMPLATE}${SUBJ}${searchstring_xfm_affine}`

  echo c3d_affine_tool -ref $input_T1w -src $input_T2prep $input_T2prep_to_T1w_mat_FSL -fsl2ras -oitk $output_T2prep_to_T1w_mat_ITK
  c3d_affine_tool -ref $input_T1w -src $input_T2prep $input_T2prep_to_T1w_mat_FSL -fsl2ras -oitk $output_T2prep_to_T1w_mat_ITK

  echo antsApplyTransforms -d 3 --float 1 --verbose 1 -i $input_T2prep -o $output_T2prep -r $input_template -t $input_xfm_warp -t $input_xfm_affine -t $output_T2prep_to_T1w_mat_ITK -n Linear
  antsApplyTransforms -d 3 --float 1 --verbose 1 -i $input_T2prep -o $output_T2prep -r $input_template -t $input_xfm_warp -t $input_xfm_affine -t $output_T2prep_to_T1w_mat_ITK -n Linear

  echo antsApplyTransforms -d 3 --float 1 --verbose 1 -i $input_T2prep -o $output_T2prep_700iso -r $template_700iso -t $input_xfm_warp -t $input_xfm_affine -t $output_T2prep_to_T1w_mat_ITK -n Linear
  antsApplyTransforms -d 3 --float 1 --verbose 1 -i $input_T2prep -o $output_T2prep_700iso -r $template_700iso -t $input_xfm_warp -t $input_xfm_affine -t $output_T2prep_to_T1w_mat_ITK -n Linear

done < "$in_csv"

exit 0
