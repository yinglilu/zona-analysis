#!/bin/bash
# Perform stats -- run after copyall
# regularInteractive on graham
# how to run on graham: regularInteractive --> neurogliaShell --> cd /project/6007967/jclau/snsx32/qmaps/
#   then:  ~/GitHub/snsx32/scripts/volumetry/BIDS_space-T1w_stats.sh -i ~/GitHub/snsx32/input/input_csv/snsx32.csv >& ~/project/snsx32/volumetry/snsx32_space-T1w.csv

#script_dir=~/GitHub/snsx32/scripts/template_building/snsx32_qmaps/snsx32_qmaps_v0.2_i09/
#csv_full_path=~/GitHub/snsx32/input/input_csv/snsx32.csv

#function for unwarping and generating warp files
function usage {
 echo ""
 echo "Stats"
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
     i ) #echo "  Input csv $OPTARG"
         in_csv=$OPTARG;;

    * ) usage
        exit 1;;
 esac
done

#echo "Input CSV file: $in_csv"

# TODO: remove hardcoded paths/variable names
rootdir=~ # used when running on graham mount versus graham itself
output_dir=$rootdir/project/snsx32/volumetry/snsx32_space-T1w/

#########################################################
# prepare directories
#########################################################

header="subjid,labelid,vol_vox,vol_mm3,x_mm3,y_mm3,z_mm3,x_vox,y_vox,z_vox,mean_T1,mean_T2,mean_R2star,mean_QSM,mean_FA,mean_MD"
echo $header
while read SUBJ; do
  #echo "---------"
  #echo $SUBJ
  #echo "---------"

  # paths to quantitative maps in T1w space
  anatdir=${output_dir}/${SUBJ}/anat
  dwidir=${output_dir}/${SUBJ}/dwi

  T1=${anatdir}/${SUBJ}_acq-MP2RAGE_run-01_T1map.nii.gz
  T2=${anatdir}/${SUBJ}_acq-SPACE_proc-prepT2_space-T1w_T2w.nii.gz
  R2star=${anatdir}/${SUBJ}_proc-qsm-sstv_space-T1w_R2star.nii.gz # TODO: fix bids-compliance issue -- qsm-sstv --> qsm_sstv
  QSM=${anatdir}/${SUBJ}_proc-qsm-sstv_space-T1w_QSM.nii.gz
  FA=${dwidir}/${SUBJ}_proc-prepdwi_space-T1w_FA.nii.gz
  MD=${dwidir}/${SUBJ}_proc-prepdwi_space-T1w_MD.nii.gz

  #########################################################
  # output metrics: volumetry, CoM, mean qMRI val
  #########################################################
  # for a given subject
  for labelnum in {1..6}
  do
    # initialize variables
    curr_label_mask=${anatdir}/${SUBJ}_space-T1w_label-0${labelnum}_roi.nii.gz

    # get volume and centre-of-mass stats
      # bash string handling: xargs = trim white space; tr to replace space with comma
    vol_stats=`fslstats $curr_label_mask -V | xargs | tr ' ' ','`
    com_mm3=`fslstats $curr_label_mask -c | xargs | tr ' ' ','`
    com_vox=`fslstats $curr_label_mask -C | xargs | tr ' ' ','`

    # get qMRI stats
    mean_T1=`fslstats $T1 -k $curr_label_mask -m | xargs`
    #mean_R1=`fslstats $R1 -k $curr_label_mask -m | xargs` # TODO
    mean_T2=`fslstats $T2 -k $curr_label_mask -m | xargs` # Note: this has been processed a lot so not a true T2
    mean_R2star=`fslstats $R2star -k $curr_label_mask -m | xargs`
    mean_QSM=`fslstats $QSM -k $curr_label_mask -m | xargs` # comment: divide by 1000 for ppm?
    mean_FA=`fslstats $FA -k $curr_label_mask -m | xargs`
    mean_MD=`fslstats $MD -k $curr_label_mask -m | xargs`

    echo "$SUBJ,$labelnum,$vol_stats,$com_mm3,$com_vox,$mean_T1,$mean_T2,$mean_R2star,$mean_QSM,$mean_FA,$mean_MD"
  done

done < "$in_csv"

exit 0
