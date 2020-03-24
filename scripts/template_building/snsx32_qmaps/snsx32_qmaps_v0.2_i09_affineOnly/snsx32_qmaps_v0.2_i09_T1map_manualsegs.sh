#!/bin/bash
# resample (SA2RAGE-corrected) T1map images into template space
# how to run on graham: regularInteractive --> neurogliaShell --> cd /project/6007967/jclau/snsx32/qmaps/
#   then: ~/GitHub/snsx32/scripts/template_building/snsx32_qmaps/snsx32_qmaps_v0.2_i09/snsx32_qmaps_v0.2_i09_T1map.sh -i ~/GitHub/snsx32/input/input_csv/snsx32.csv  >& logs/snsx32_qmaps_v0.2_i09_T1map.log &

#function for unwarping and generating warp files
function usage {
 echo ""
 echo "Resample all original T1map images into AFFINE-ONLY template space (i.e. disregarding non-linear warp)"
 echo ""
 echo "Required args:"
 echo "  <subjid>"
# echo "  -i input_csv with subject names (e.g. sub-C020)"
 echo ""
}

if [ "$#" -lt 1 ]
then
 usage
 exit 1
fi

# TODO: remove hardcoded paths/variable names
input_dir=/project/6007967/cfmm-bids/Khan/SNSX_7T/derivatives/mp2ragecorrect/
in_seg_dir=/project/6007967/jclau/zona/segmentations/warped_seg/
output_dir=/project/6007967/jclau/snsx32/qmaps/snsx32_qmaps_v0.2_i09_affineOnly/

# input template
TEMPLATE=snsx32_v0.2_i09
template_dir=/project/6007967/jclau/snsx32/templates/snsx32_v0.2/${TEMPLATE}/
input_template=${template_dir}/${TEMPLATE}template0.nii.gz

# also 700iso version
template_700iso=${output_dir}/templates/${TEMPLATE}template0_700iso.nii.gz
mkdir -p ${output_dir}/templates/
if [ ! -e $template_700iso ]
then
flirt -interp trilinear -ref $input_template -in $input_template -applyisoxfm 0.7 -out $template_700iso
fi

# can use read and IFS=',' to parse multicolumn csvs
# https://stackoverflow.com/questions/13434260/loop-through-csv-file-and-create-new-csv-file-with-while-read
#while read SUBJ; do

for SUBJ in $@
do
  echo "---------"
  echo $SUBJ
  echo "---------"
  input_T1map=${input_dir}/${SUBJ}/anat/${SUBJ}_acq-MP2RAGE_run-01_proc-SA2RAGE_T1map.nii.gz
  output_T1map=${output_dir}/${SUBJ}/anat/${SUBJ}_acq-MP2RAGE_space-templateAffineOnly_T1map.nii.gz
  output_T1map_700iso=${output_dir}/${SUBJ}/anat/${SUBJ}_acq-MP2RAGE_space-templateAffineOnly_res-700iso_T1map.nii.gz

  output_R1map_native=${output_dir}/${SUBJ}/anat/${SUBJ}_acq-MP2RAGE_run-01_proc-SA2RAGE_R1map.nii.gz
  output_R1map=${output_dir}/${SUBJ}/anat/${SUBJ}_acq-MP2RAGE_space-templateAffineOnly_R1map.nii.gz
  output_R1map_700iso=${output_dir}/${SUBJ}/anat/${SUBJ}_acq-MP2RAGE_space-templateAffineOnly_res-700iso_R1map.nii.gz

  mkdir -p ${output_dir}/${SUBJ}/anat/

  searchstring_xfm_affine=*MP2RAGE*T1w*GenericAffine.mat

  input_xfm_affine=`eval ls ${template_dir}/${TEMPLATE}${SUBJ}${searchstring_xfm_affine}`

  if false
  then
  # T1map transformation
  echo antsApplyTransforms -d 3 --float 1  -i $input_T1map -o $output_T1map -r $input_template -t $input_xfm_affine -n Linear
  antsApplyTransforms -d 3 --float 1  -i $input_T1map -o $output_T1map -r $input_template -t $input_xfm_affine -n Linear
  echo antsApplyTransforms -d 3 --float 1  -i $input_T1map -o $output_T1map_700iso -r $template_700iso -t $input_xfm_affine -n Linear
  antsApplyTransforms -d 3 --float 1  -i $input_T1map -o $output_T1map_700iso -r $template_700iso -t $input_xfm_affine -n Linear

  # T1map --> R1map; convert milliseconds --> seconds then get reciprocal
  # TODO: this functionality should be migrated to mp2rage_correction or prepMP2RAGE
  echo fslmaths $input_T1map -div 1000 -recip $output_R1map_native
  fslmaths $input_T1map -div 1000 -recip $output_R1map_native

  echo antsApplyTransforms -d 3 --float 1  -i $output_R1map_native -o $output_R1map -r $input_template -t $input_xfm_affine -n Linear
  antsApplyTransforms -d 3 --float 1  -i $output_R1map_native -o $output_R1map -r $input_template -t $input_xfm_affine -n Linear
  echo antsApplyTransforms -d 3 --float 1  -i $output_R1map_native -o $output_R1map_700iso -r $template_700iso -t $input_xfm_affine -n Linear
  antsApplyTransforms -d 3 --float 1  -i $output_R1map_native -o $output_R1map_700iso -r $template_700iso -t $input_xfm_affine -n Linear
  fi

  #also transform segmentations from subj native space to templateAffineOnly
  in_fuzzy=$in_seg_dir/${SUBJ}/fuzzy
  out_fuzzy=${output_dir}/${SUBJ}/fuzzy
  mkdir -p $out_fuzzy
  for in_seg in `ls $in_fuzzy/*.nii.gz`
  do
	  
	suffix=${in_seg##*/}
	suffix=${suffix#*_}

	out_seg=$out_fuzzy/${SUBJ}_space-templateAffineOnly_${suffix}
	out_seg_700iso=$out_fuzzy/${SUBJ}_space-templateAffineOnly_res-700iso_${suffix}
echo  	antsApplyTransforms -d 3 --float 1  -i $in_seg -o $out_seg -r $input_template -t $input_xfm_affine -n Linear
  	antsApplyTransforms -d 3 --float 1  -i $in_seg -o $out_seg -r $input_template -t $input_xfm_affine -n Linear
echo	antsApplyTransforms -d 3 --float 1  -i $in_seg -o $out_seg_700iso -r $template_700iso -t $input_xfm_affine -n Linear
	antsApplyTransforms -d 3 --float 1  -i $in_seg -o $out_seg_700iso -r $template_700iso -t $input_xfm_affine -n Linear

 done

 done
#done < "$in_csv"

exit 0

