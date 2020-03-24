#!/bin/bash
# resample preprocessed T2space images (in subject T1w space) into template space
# how to run on graham: regularInteractive --> neurogliaShell --> cd /project/6007967/jclau/snsx32/sandbox/
# ~/GitHub/snsx32/scripts/template_building/snsx32_qavg/snsx32_qavg_T2space_bootstrapped.sh -i  ~/GitHub/snsx32/scripts/template_building/snsx32_qavg/snsx32_qavg_proc-prepT2_space-T1w_T2w_QCed.csv >& /project/6007967/jclau/snsx32/qmaps/snsx32_qavg_T2w_bootstrapped.log &

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
output_dir=/project/6007967/jclau/snsx32/qmaps/

# input template; also create 700 micron resampled version
TEMPLATE=snsx32_v0.1_i09
template_dir=/project/6007967/jclau/snsx32/templates/snsx32_v0.1/${TEMPLATE}/
input_template=${template_dir}/${TEMPLATE}template0.nii.gz
#template_700iso=${output_dir}/templates/${TEMPLATE}template0_700iso.nii.gz
#mkdir -p ${output_dir}/templates/
#flirt -interp trilinear -ref $input_template -in $input_template -applyisoxfm 0.7 -out $output_template_700iso

# can use read and IFS=',' to parse multicolumn csvs
# https://stackoverflow.com/questions/13434260/loop-through-csv-file-and-create-new-csv-file-with-while-read
IFS=','
while read SUBJ SUBJ_PATH; do
  echo "---------"
  echo $SUBJ
  echo $SUBJ_PATH
  echo "---------"
  input_qmap=$SUBJ_PATH
  output_qmap=${output_dir}/${SUBJ}/anat/${SUBJ}_acq-SPACE_proc-prepT2_space-template_T2w.nii.gz
  output_qmap_700iso=${output_dir}/${SUBJ}/anat/${SUBJ}_acq-SPACE_space-template_res-700iso_T2w.nii.gz
#  output_qmap_inm=${output_dir}/${SUBJ}/anat/${SUBJ}_acq-SPACE_proc-prepT2_space-template_T2w_inm.nii.gz
#  output_qmap_700iso_inm=${output_dir}/${SUBJ}/anat/${SUBJ}_acq-SPACE_space-template_res-700iso_T2w_inm.nii.gz

  mkdir -p ${output_dir}/${SUBJ}/anat/

  searchstring_xfm_warp=*MP2RAGE*T1w*Warp.nii*
  searchstring_xfm_affine=*MP2RAGE*T1w*GenericAffine.mat

  input_xfm_warp=`eval ls ${template_dir}/${TEMPLATE}${SUBJ}${searchstring_xfm_warp} | sort -nr | head -n 1` # just want Warp not InverseWarp
  input_xfm_affine=`eval ls ${template_dir}/${TEMPLATE}${SUBJ}${searchstring_xfm_affine}`

  echo antsApplyTransforms -d 3 --float 1 --verbose 1 -i $input_qmap -o $output_qmap -r $input_template -t $input_xfm_warp -t $input_xfm_affine -n Linear
  antsApplyTransforms -d 3 --float 1 --verbose 1 -i $input_qmap -o $output_qmap -r $input_template -t $input_xfm_warp -t $input_xfm_affine -n Linear

#  echo ImageMath 3 $output_qmap_inm HistogramMatch $output_qmap $output_dir/snsx32_v0.1_i09_avg_T2w.nii.gz
#  ImageMath 3 $output_qmap_inm HistogramMatch $output_qmap $output_dir/snsx32_v0.1_i09_avg_T2w.nii.gz

  # resample from 0.5 --> 0.7; TODO: optimize
  echo flirt -interp trilinear -ref $input_template -in $output_qmap -applyisoxfm 0.7 -out $output_qmap_700iso
  flirt -interp trilinear -ref $input_template -in $output_qmap -applyisoxfm 0.7 -out $output_qmap_700iso

#  echo flirt -interp trilinear -ref $input_template -in $output_qmap_inm -applyisoxfm 0.7 -out $output_qmap_700iso_inm
#  flirt -interp trilinear -ref $input_template -in $output_qmap_inm -applyisoxfm 0.7 -out $output_qmap_700iso_inm
done < "$in_csv"

# MNI2009b space (0.5 mm)
echo AverageImages 3 $output_dir/snsx32_v0.1_i09_avg_T2w.nii.gz 0 `find $output_dir/ -name '*space-template_T2w.nii.gz' | sort`
AverageImages 3 $output_dir/snsx32_v0.1_i09_avg_T2w.nii.gz 0 `find $output_dir/ -name '*space-template_T2w.nii.gz' | sort`
echo ImageMath 3 $output_dir/snsx32_v0.1_i09_avg_sharpened_T2w.nii.gz Sharpen $output_dir/snsx32_v0.1_i09_avg_T2w.nii.gz
ImageMath 3 $output_dir/snsx32_v0.1_i09_avg_sharpened_T2w.nii.gz Sharpen $output_dir/snsx32_v0.1_i09_avg_T2w.nii.gz

# template in 0.7 mm
echo AverageImages 3 $output_dir/snsx32_v0.1_i09_avg_T2w_700iso.nii.gz 0 `find $output_dir/ -name '*space-template_res-700iso_T2w.nii.gz' | sort`
AverageImages 3 $output_dir/snsx32_v0.1_i09_avg_T2w_700iso.nii.gz 0 `find $output_dir/ -name '*space-template_res-700iso_T2w.nii.gz' | sort`
echo ImageMath 3 $output_dir/snsx32_v0.1_i09_avg_sharpened_T2w_700iso.nii.gz Sharpen $output_dir/snsx32_v0.1_i09_avg_T2w_700iso.nii.gz
ImageMath 3 $output_dir/snsx32_v0.1_i09_avg_sharpened_T2w_700iso.nii.gz Sharpen $output_dir/snsx32_v0.1_i09_avg_T2w_700iso.nii.gz

exit 0
