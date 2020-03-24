#!/bin/bash

#depends on ANTS

# basic usage: ./01_propManualToSubj.sh sub-C001
# neuroglia usage to run for all subjects:
#   neurogliaBatch ~/GitHub/snsx32/scripts/warp_to_subj/01_propManualToSubj.sh /home/jclau/GitHub/snsx32/input/input_csv/snsx32.csv -j ShortSkinny


in_seg_dir=/home/jclau/GitHub/zona-analysis/data/
in_ants_dir=/project/6007967/jclau/snsx32/templates/snsx32_v0.2/snsx32_v0.2_i09
out_seg_dir=/project/6007967/jclau/zona/segmentations/warped_seg

input_csv_dir=/home/jclau/GitHub/snsx32/input/input_csv

for subj in $@
do

 subjid=${subj##*-}

 warp=`ls $in_ants_dir/*${subjid}*[0-9]Warp.nii.gz`
 inversewarp=`ls $in_ants_dir/*${subjid}*[0-9]InverseWarp.nii.gz`
 affine=`ls $in_ants_dir/*${subjid}*[0-9]GenericAffine.mat`

 echo subj: $subj
 echo warp: $warp
 echo inverse warp: $inversewarp
 echo affine: $affine

 #get T1w ref image from csv file:
 target_ref=`grep $subj $input_csv_dir/snsx32_T1w_gradcorrected.csv`

 if [ ! -e $target_ref ]
 then
	  echo "target reference: $target_ref does not exist!"
	  continue
  fi

 #loop through manual types
for in_seg in $in_seg_dir/consensus_seg/fuzzy/*.nii.gz
do

folder_name=${in_seg%/*}
folder_name=${folder_name##*/}

seg_name=${in_seg##*/}
seg_name=${seg_name%%.*}


out_subj_dir=${out_seg_dir}/${subj}/
out_seg=${out_subj_dir}/fuzzy/${subj}_${seg_name}.nii.gz
out_seg_bin=${out_subj_dir}/binary/${subj}_${seg_name}_bin.nii.gz

mkdir -p $out_subj_dir/fuzzy
mkdir -p $out_subj_dir/binary
echo out_subj_dir $out_subj_dir
echo out_seg $out_seg

echo antsApplyTransforms -d 3 \
	--interpolation Linear \
	-i $in_seg\
	-o $out_seg\
	-r $target_ref\
	-t [$affine, 1] \
	-t $inversewarp

antsApplyTransforms -d 3 \
	--interpolation Linear \
	-i $in_seg\
	-o $out_seg\
	-r $target_ref\
	-t [$affine, 1] \
	-t $inversewarp

# create binarized version
echo fslmaths $out_seg -thr 0.5 -bin $out_seg_bin
fslmaths $out_seg -thr 0.5 -bin $out_seg_bin

done

done
