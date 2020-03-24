#!/bin/bash
# resample all original T1w images into template space; note: some slight differences between i09 and this template due to rigid transformation drift
# how to run on graham: regularInteractive --> neurogliaShell --> cd /project/6007967/jclau/snsx32/qmaps/
#   then: ~/GitHub/snsx32/scripts/template_building/snsx32_qmaps/snsx32_qmaps_v0.2_i09/snsx32_qmaps_v0.2_i09_T1w.sh -i ~/GitHub/snsx32/input/input_csv/snsx32.csv  >& logs/snsx32_qmaps_v0.2_i09_T1w.log &

#function for unwarping and generating warp files
function usage {
 echo ""
 echo "Resample all original T1w images into template space"
 echo ""
 echo "Required args:"
 echo "  -i input_csv with subject names (e.g. sub-C020)"
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
output_dir=/project/6007967/jclau/snsx32/qmaps/snsx32_qmaps_v0.2_i09/

# input template; also create 700 micron resampled version
TEMPLATE=snsx32_v0.2_i09
template_dir=/project/6007967/jclau/snsx32/templates/snsx32_v0.2/${TEMPLATE}/
input_template=${template_dir}/${TEMPLATE}template0.nii.gz

# 700iso version
template_700iso=${output_dir}/templates/${TEMPLATE}template0_700iso_T1w.nii.gz
mkdir -p ${output_dir}/templates/
echo flirt -interp trilinear -ref $input_template -in $input_template -applyisoxfm 0.7 -out $template_700iso
flirt -interp trilinear -ref $input_template -in $input_template -applyisoxfm 0.7 -out $template_700iso

# can use read and IFS=',' to parse multicolumn csvs
# https://stackoverflow.com/questions/13434260/loop-through-csv-file-and-create-new-csv-file-with-while-read
while read SUBJ; do
  echo "---------"
  echo $SUBJ
  echo "---------"
  input_qmap=${input_dir}/${SUBJ}/anat/${SUBJ}_acq-MP2RAGE_run-01_T1w.nii.gz
  output_qmap=${output_dir}/${SUBJ}/anat/${SUBJ}_acq-MP2RAGE_space-template_T1w.nii.gz
  output_qmap_700iso=${output_dir}/${SUBJ}/anat/${SUBJ}_acq-MP2RAGE_space-template_res-700iso_T1w.nii.gz

  mkdir -p ${output_dir}/${SUBJ}/anat/

  searchstring_xfm_warp=*MP2RAGE*T1w*Warp.nii*
  searchstring_xfm_affine=*MP2RAGE*T1w*GenericAffine.mat

  input_xfm_warp=`eval ls ${template_dir}/${TEMPLATE}${SUBJ}${searchstring_xfm_warp} | sort -nr | head -n 1` # just want Warp not InverseWarp
  input_xfm_affine=`eval ls ${template_dir}/${TEMPLATE}${SUBJ}${searchstring_xfm_affine}`

  echo antsApplyTransforms -d 3 --float 1 --verbose 1 -i $input_qmap -o $output_qmap -r $input_template -t $input_xfm_warp -t $input_xfm_affine -n Linear
  antsApplyTransforms -d 3 --float 1 --verbose 1 -i $input_qmap -o $output_qmap -r $input_template -t $input_xfm_warp -t $input_xfm_affine -n Linear

  echo antsApplyTransforms -d 3 --float 1 --verbose 1 -i $input_qmap -o $output_qmap_700iso -r $template_700iso -t $input_xfm_warp -t $input_xfm_affine -n Linear
  antsApplyTransforms -d 3 --float 1 --verbose 1 -i $input_qmap -o $output_qmap_700iso -r $template_700iso -t $input_xfm_warp -t $input_xfm_affine -n Linear

done < "$in_csv"

exit 0
