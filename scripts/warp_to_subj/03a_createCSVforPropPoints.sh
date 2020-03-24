#!/bin/bash
# creates the CSV file for notebook analysis with propagated points in subj space
# run locally on rete (graham was down) 20200307: ~/graham/project/zona/psa_points/
# ~/graham/GitHub/snsx32/scripts/warp_to_subj/03a_createCSVforPropPoints.sh -i ~/GitHub/snsx32/input/input_csv/snsx32.csv >& output_data/psa_points.csv

function usage {
 echo ""
 echo "Create CSV from subject propagated PSA points"
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
     i ) 
         in_csv=$OPTARG;;

    * ) usage
        exit 1;;
 esac
done

input_dir=~/graham/project/zona/psa_points/output_data/
output_dir=~/graham/project/zona/psa_points/output_data/

printf "subjid,x,y,z,target_desc\n"

while read SUBJ; do

#SUBJ="sub-C001"

  curr_subj_fcsv=$input_dir/$SUBJ/psa/${SUBJ}_psa.fcsv
  N=1

  while read line
  do
    if [[ $N -gt 3 ]]
    then
      parsedline=`echo $line | cut -d, -f 2,3,4,12`
      echo "$SUBJ,$parsedline"
    fi
    ((N++))
  done < $curr_subj_fcsv 

done < $in_csv 



