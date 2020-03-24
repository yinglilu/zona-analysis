#!/bin/bash
# run locally on rete (graham was down) 20180823: ~/Projects/snsx32/manual_masks

for raternum in {1..3}
do
  for labelnum in {1..6}
  do
    for sessionnum in {1..2}
    do
      echo fslmaths snsx32_v0.2_i09_Rater0${raternum}_${sessionnum}_manual_masks.nii.gz -thr ${labelnum} -uthr ${labelnum} -bin snsx32_v0.2_i09_Rater0${raternum}_${sessionnum}_Label0${labelnum}.nii.gz
      fslmaths snsx32_v0.2_i09_Rater0${raternum}_${sessionnum}_manual_masks.nii.gz -thr ${labelnum} -uthr ${labelnum} -bin snsx32_v0.2_i09_Rater0${raternum}_${sessionnum}_Label0${labelnum}.nii.gz
    done
  done
done

# create binary for each label and session
for labelnum in {1..6}
do
  echo fslmaths snsx32_v0.2_i09_Rater01_1_Label0${labelnum}.nii.gz -add snsx32_v0.2_i09_Rater02_1_Label0${labelnum}.nii.gz -add snsx32_v0.2_i09_Rater03_1_Label0${labelnum}.nii.gz snsx32_v0.2_i09_Rater01_2_Label0${labelnum}.nii.gz -add snsx32_v0.2_i09_Rater02_2_Label0${labelnum}.nii.gz -add snsx32_v0.2_i09_Rater03_2_Label0${labelnum}.nii.gz -div 6 snsx32_v0.2_i09_RatersAll_Label0${labelnum}_prob.nii.gz
  fslmaths snsx32_v0.2_i09_Rater01_1_Label0${labelnum}.nii.gz -add snsx32_v0.2_i09_Rater02_1_Label0${labelnum}.nii.gz -add snsx32_v0.2_i09_Rater03_1_Label0${labelnum}.nii.gz -add snsx32_v0.2_i09_Rater01_2_Label0${labelnum}.nii.gz -add snsx32_v0.2_i09_Rater02_2_Label0${labelnum}.nii.gz -add snsx32_v0.2_i09_Rater03_2_Label0${labelnum}.nii.gz -div 6 snsx32_v0.2_i09_RatersAll_Label0${labelnum}_prob.nii.gz
  echo fslmaths snsx32_v0.2_i09_RatersAll_Label0${labelnum}_prob.nii.gz -thr 0.5 -bin snsx32_v0.2_i09_RatersAll_Label0${labelnum}_prob_bin.nii.gz
  fslmaths snsx32_v0.2_i09_RatersAll_Label0${labelnum}_prob.nii.gz -thr 0.5 -bin snsx32_v0.2_i09_RatersAll_Label0${labelnum}_prob_bin.nii.gz
done

