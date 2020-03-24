#!/bin/bash

#  to generate:  regularSubmit -j 2core8gb16h ./genSnapsZonaSNSX.sh ../../input/input_csv/snsx32.csv /project/6007967/jclau/snsx32/snapshots/

execpath=`dirname $0`
execpath=`realpath $execpath`

input_csv=$1
out_folder=$2

if [ "$#" -lt 2 ]
then
	echo "Usage: $0 <input_csv> <out_folder>"
	exit 0
fi

mkdir -p $out_folder

#./scripts/snsx32/input/input_csv/snsx32.csv 

for subj in `cat $input_csv`
do 
	echo $subj; 

	anat=/project/6007967/jclau/snsx32/qmaps/snsx32_qmaps_v0.2_i09_affineOnly/${subj}/anat/${subj}_acq-MP2RAGE_space-templateAffineOnly_T1map.nii.gz


	seg_cmd=""
	for label in raters_RN_L raters_RN_R raters_STN_L raters_STN_R exprater_ZI_L exprater_ZI_R exprater_fct_L exprater_fct_R
	do
		seg=/project/6007967/jclau/snsx32/qmaps/snsx32_qmaps_v0.2_i09_affineOnly/${subj}/fuzzy/${subj}_space-templateAffineOnly_${label}.nii.gz
		seg_cmd="$seg_cmd -s $seg"
	done

	#run command to gen snapshot
	mkdir -p $out_folder/axial $out_folder/coronal

	anat_opts="--displayRange 1000 2000 --interpolation spline"

	out=$out_folder/axial/${subj}_axial.png
	$execpath/genSegSnap.sh -a $anat -c ./colors_RRGGBB.txt -o $out $seg_cmd -z  -A "$anat_opts"
	
	out=$out_folder/coronal/${subj}_coronal.png
	$execpath/genSegSnap_hackCoronal.sh -a $anat -c ./colors_RRGGBB.txt -o $out $seg_cmd -y  -A "$anat_opts"


done
