#!/bin/bash
# run locally on rete (graham was down) 20180823: ~/Projects/snsx32/manual_masks
# to run: ./02_get_volumes.sh > volume_stats.csv

echo "rater,session,label,vol_voxels,vol_mm3,intrarater_intersection,intrarater_union,dice_intersection,dice_truth"

workdir=./workdir/
mkdir -p $workdir

for raternum in {1..3}
do
  for labelnum in {1..6}
  do
    for sessionnum in {1..2}
    do
      curr_label=snsx32_v0.2_i09_Rater0${raternum}_${sessionnum}_Label0${labelnum}.nii.gz
      output_intrarater_intersection_nii=${workdir}/snsx32_v0.2_i09_Rater0${raternum}_${sessionnum}_Label0${labelnum}_intrarater_intersection.nii.gz
      output_intrarater_union_nii=${workdir}/snsx32_v0.2_i09_Rater0${raternum}_${sessionnum}_Label0${labelnum}_intrarater_union.nii.gz
      output_dice_intersection_nii=${workdir}/snsx32_v0.2_i09_Rater0${raternum}_${sessionnum}_Label0${labelnum}_dice_intersection.nii.gz

      vol_str=`fslstats $curr_label -V | xargs | sed -e 's/\s/,/g'`

      intrarater_intersection="NA"
      intrarater_union="NA"
      dice_intersection="NA"
      dice_truth="NA"

      if [ $sessionnum -eq 1 ]
      then
        other_rater_label=snsx32_v0.2_i09_Rater0${raternum}_2_Label0${labelnum}.nii.gz
        fslmaths $curr_label -mul $other_rater_label $output_intrarater_intersection_nii
        fslmaths $curr_label -add $other_rater_label -bin $output_intrarater_union_nii
        intrarater_intersection=`fslstats $output_intrarater_intersection_nii -V | cut -d' ' -f1 | xargs`
        intrarater_union=`fslstats $output_intrarater_union_nii -V | cut -d' ' -f1 | xargs`
      fi

      all_rater_label=snsx32_v0.2_i09_RatersAll_Label0${labelnum}_prob_bin.nii.gz
      fslmaths $curr_label -mul $all_rater_label $output_dice_intersection_nii
      dice_intersection=`fslstats $output_dice_intersection_nii -V | cut -d' ' -f1 | xargs`
      dice_truth=`fslstats $all_rater_label -V | cut -d' ' -f1 | xargs`
      rater_str="$intrarater_intersection,$intrarater_union,$dice_intersection,$dice_truth"

      printf "Rater0${raternum},$sessionnum,$labelnum,%s,%s\n" $vol_str,$rater_str
    done
  done
done

