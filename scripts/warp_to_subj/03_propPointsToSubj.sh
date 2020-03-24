#!/bin/bash

#depends on ANTS; modification of 01_propManualToSubj.sh for handling points (i.e. consensus PSA point placements)

# basic usage: ./03_propPointsToSubj.sh sub-C001
# neuroglia usage to run for all subjects:
#   neurogliaBatch ~/GitHub/snsx32/scripts/warp_to_subj/03_propPointsToSubj.sh /home/jclau/GitHub/snsx32/input/input_csv/snsx32.csv -j ShortSkinny

# points to transform (note: in Slicer format)
in_points=/home/jclau/project/zona/psa_points/input_data/PSA_Consensus.fcsv

in_ants_dir=/project/6007967/jclau/snsx32/templates/snsx32_v0.2/snsx32_v0.2_i09
out_points_dir=/home/jclau/project/zona/psa_points/output_data

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

out_subj_dir=${out_points_dir}/${subj}/
out_points=${out_subj_dir}/psa/${subj}_psa.fcsv

mkdir -p $out_subj_dir/psa
echo out_subj_dir $out_subj_dir
echo out_points $out_points

echo python3 /home/jclau/GitHub/snsx32/scripts/warp_to_subj/antsApplyTransformsToSlicerFCSV.py \
	-i $in_points \
	-o $out_points \
	-a $affine \
	-w $warp \
	-x $inversewarp

python3 /home/jclau/GitHub/snsx32/scripts/warp_to_subj/antsApplyTransformsToSlicerFCSV.py \
	-i $in_points \
	-o $out_points \
	-a $affine \
	-w $warp \
	-x $inversewarp

#antsApplyTransforms -d 3 \
#	--interpolation Linear \
#	-i $in_seg\
#	-o $out_points\
#	-r $target_ref\
#	-t [$affine, 1] \
#	-t $inversewarp


done
