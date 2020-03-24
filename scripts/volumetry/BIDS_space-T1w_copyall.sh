#!/bin/bash
# Create BIDS-compliant directory with all processed qmaps resampled in T1w space + derived ROIs
# regularInteractive on graham
# how to run on graham: regularInteractive --> neurogliaShell --> cd /project/6007967/jclau/snsx32/qmaps/
#   then: ~/GitHub/snsx32/scripts/volumetry/BIDS_space-T1w_copyall.sh -i ~/GitHub/snsx32/input/input_csv/snsx32.csv  >& logs/snsx32_volumetry.log &

#script_dir=~/GitHub/snsx32/scripts/template_building/snsx32_qmaps/snsx32_qmaps_v0.2_i09/
#csv_full_path=~/GitHub/snsx32/input/input_csv/snsx32.csv

#function for unwarping and generating warp files
function usage {
 echo ""
 echo "Create BIDS-compliant directory with all processed qmaps resampled in T1w space + derived ROIs"
 echo ""
 echo "Required args:"
 echo "  -i input_csv with SUBJect names (e.g. sub-C020)"
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
rootdir=~ # used when running on graham mount versus graham itself
output_dir=$rootdir/project/snsx32/volumetry/snsx32_space-T1w/
TEMPLATE=snsx32_v0.2_i09
template_dir=/project/6007967/jclau/snsx32/templates/snsx32_v0.2/${TEMPLATE}/

mkdir -p $output_dir

#########################################################
# prepare directories
#########################################################

T1dir=$rootdir/projects/rrg-akhanf/cfmm-bids/Khan/SNSX_7T/derivatives/gradcorrect_0.0.1h/
T2dir=$rootdir/project/SNSX_7T/derivatives/prepT2space_v0.0.2b_gradcorrected/
QSMdir=$rootdir/project/SNSX_7T/derivatives/qsmToT1/
DWIdir=$rootdir/projects/rrg-akhanf/cfmm-bids/Khan/SNSX_7T/derivatives/prepdwi_0.0.7a_res0.75/prepdwi/
XFMdir=$rootdir/project/snsx32/templates/snsx32_v0.2/snsx32_v0.2_i09/
ROIdir=$rootdir/project/snsx32/manual_masks/

while read SUBJ; do
  echo "---------"
  echo $SUBJ
  echo "---------"

  subjdir=${output_dir}/${SUBJ}/anat
  mkdir -p $subjdir

  ####################
  # Copy existing qmaps
  ####################
  input_T1=${T1dir}/${SUBJ}/anat/${SUBJ}_acq-MP2RAGE_run-01_T1map.nii.gz
  output_T1=${subjdir}/${SUBJ}_acq-MP2RAGE_run-01_T1map.nii.gz
  echo cp $input_T1 $output_T1
  cp $input_T1 $output_T1

  input_T2=${T2dir}/${SUBJ}/anat/${SUBJ}_acq-SPACE_proc-prepT2_space-T1w_T2w.nii.gz
  output_T2=${subjdir}/${SUBJ}_acq-SPACE_proc-prepT2_space-T1w_T2w.nii.gz
  echo cp $input_T2 $output_T2
  cp $input_T2 $output_T2

  input_R2star=${QSMdir}/${SUBJ}/anat/${SUBJ}_proc-qsm_sstv_space-T1w_R2star.nii.gz # TODO: change qsm-sstv to qsm_sstv to be BIDS compliant with naming
  output_R2star=${subjdir}/${SUBJ}_proc-qsm_sstv_space-T1w_R2star.nii.gz
  echo cp $input_R2star $output_R2star
  cp $input_R2star $output_R2star

  input_QSM=${QSMdir}/${SUBJ}/anat/${SUBJ}_proc-qsm_sstv_space-T1w_QSM.nii.gz # TODO: change qsm-sstv to qsm_sstv to be BIDS compliant with naming
  output_QSM=${subjdir}/${SUBJ}_proc-qsm_sstv_space-T1w_QSM.nii.gz
  echo cp $input_QSM $output_QSM
  cp $input_QSM $output_QSM

  ####################
  # Resample FA and MD maps into same resolution as T1
  ####################
  subjdir=${output_dir}/${SUBJ}/dwi # TODO: better path handling in the future
  mkdir -p $subjdir

  input_FA=${DWIdir}/${SUBJ}/dwi/${SUBJ}_dwi_space-T1wGC_proc-FSL_FA.nii.gz
  output_FA=${subjdir}/${SUBJ}_proc-prepdwi_space-T1w_FA.nii.gz
  echo reg_resample -ref $input_T1 -flo $input_FA -res $output_FA -NN 0
  reg_resample -ref $input_T1 -flo $input_FA -res $output_FA -NN 0
  
  input_MD=${DWIdir}/${SUBJ}/dwi/${SUBJ}_dwi_space-T1wGC_proc-FSL_MD.nii.gz
  output_MD=${subjdir}/${SUBJ}_proc-prepdwi_space-T1w_MD.nii.gz
  echo reg_resample -ref $input_T1 -flo $input_MD -res $output_MD -NN 0
  reg_resample -ref $input_T1 -flo $input_MD -res $output_MD -NN 0

  ####################
  # Apply transform for subthalamic ROIs
  ####################
  for labelnum in {1..6}
  do

    subjdir=${output_dir}/${SUBJ}/anat # TODO: better path handling in the future
    mkdir -p $subjdir

    # TODO: figure out parsing of Warp and InverseWarp -- see snsx32_qmaps_v0.2_i09_T1map.sh for example
    curr_label=$ROIdir/snsx32_v0.2_i09_meanbin_1_Label0${labelnum}.nii.gz
    out_label=${subjdir}/${SUBJ}_space-T1w_label-0${labelnum}_roi.nii.gz # TODO: actually implement proper zero padding

    searchstring_xfm_warp=*MP2RAGE*T1w*Warp.nii*
    searchstring_xfm_affine=*MP2RAGE*T1w*GenericAffine.mat
    
    input_xfm_inversewarp=`eval ls ${template_dir}/${TEMPLATE}${SUBJ}${searchstring_xfm_warp} | sort -n | head -n 1` # just want InverseWarp from TemplateCreation script
    input_xfm_affine=`eval ls ${template_dir}/${TEMPLATE}${SUBJ}${searchstring_xfm_affine}`

    echo antsApplyTransforms -d 3 --float 1 --verbose 1 -i $curr_label -o $out_label -r $input_T1 -t [$input_xfm_affine,1] -t $input_xfm_inversewarp -n NearestNeighbor
    antsApplyTransforms -d 3 --float 1 --verbose 1 -i $curr_label -o $out_label -r $input_T1 -t [$input_xfm_affine,1] -t $input_xfm_inversewarp -n NearestNeighbor
  done
done < "$in_csv"

exit 0
