
#!/bin/bash

function usage {
echo ""
echo "Usage: $0 <required and optional parameters>"
echo " Required parameters:"
echo "  -a <anatomical img> (e.g. T1w.nii.gz)"
echo "  -o <output_file> (e.g. output.png)"
echo " Optional parameters:"
echo "  -s <overlay segmentation outline> (optional, if more than one, use -s <seg1> -s <seg2>)"
echo "  -c <txt_file> (txt file with R G B on each line, loops through these colors)"
echo "  -t <threshold for masks> (default 0.5)"
echo "  -x   (output X slice only)"
echo "  -y   (output Y slice only)"
echo "  -z   (output Z slice only)"
echo "  -w \"wx wy wz\"  (specify location in world coords - default 0 0 0, or avg centroid of segs)"
echo "  -A \"...\" (options for anatomical image)"
echo ""
}

execpath=`dirname $0`
execpath=`realpath $execpath`


anat=""
out=""
segs=()
threshold=0.5
slice=x
worldLoc="0 0 0"
outlineWidth=12
anat_opts=""

#size of output images (make this an option later..)
sx=2000
sy=1500

#default colors txt is color set from matlab
echo "execpath: $execpath"
color_txt=$execpath/colors_MATLAB.txt

if [ "$#" -lt 1 ]
then
	usage
	exit 1
fi



while getopts "s:c:a:o:t:xyzw:A:" options; do
 case $options in
    a )     if [ ! -e $OPTARG ]
	    then 
		    echo "  ERROR: $OPTARG does not exist!"
		    exit 1
	    fi
	echo "  Using anatomical: $OPTARG"
    	anat=$OPTARG;;
    o ) echo "  Using output: $OPTARG"
    	out=$OPTARG;;
    s )    if [ ! -e $OPTARG ]
	    then 
		    echo "  ERROR: $OPTARG does not exist!"
		    exit 1
	    fi
	echo "  Adding seg overlay: $OPTARG"
	segs+=("$OPTARG");;
    c ) echo "  Using custom color txt: $OPTARG"
	    color_txt=$OPTARG;;
    x ) echo "  Using x slice"
	    slice=x;;
    y ) echo "  Using y slice"
	    slice=y;;
    z ) echo "  Using z slice"
	    slice=z;;
    w ) echo "  Using worldLoc = $OPTARG"
	    worldLoc=$OPTARG;;
    A ) echo "  Using anat opts = $OPTARG"
	    anat_opts=$OPTARG;;

   * ) usage
	 exit 1;;
  esac
done	


#make arg for this
zoom=2500;




#set zoom level
slice_opts="--${slice}zoom $zoom"

#hide other slices (e.g. hide y-z if vis x)
for hslice in x y z
do
  if [ ! "$slice" = "$hslice" ]
  then
	  slice_opts="$slice_opts --hide${hslice}"
  fi
done

overlay_opts="--overlayType mask  --threshold $threshold 1.01 --outline --outlineWidth $outlineWidth --interpolation spline"
seg_cmd=""

#will cycle through colors in text file
n_colors=`cat $color_txt | wc -l`
color_i=0

centroid_txt=/tmp/centroids_${RANDOM}.txt
rm -f $centroid_txt

#loop through seg overlays
nsegs=${#segs[@]}
echo "nsegs: $nsegs"
for i  in  `seq 0 $((nsegs-1))`
do

color_ind=$((color_i % $n_colors))
color=`head -n $((color_ind+1)) $color_txt | tail -n 1`

echo "seg: ${segs[$i]}, color: $color"
seg_cmd="$seg_cmd ${segs[$i]} --maskColour $color $overlay_opts"

if [  "$worldLoc" = "0 0 0" ]
then
#write centroid to file 
neuroglia fslstats ${segs[$i]} -c >> $centroid_txt
fi

#increment color
color_i=$((color_i+1))
done


if [  "$worldLoc" = "0 0 0" -a -e $centroid_txt ]
then
#get average centroid for location of slice
xc=`awk '{ total += $1; count++ } END { print total/count }' $centroid_txt`
yc=`awk '{ total += $2; count++ } END { print total/count }' $centroid_txt`
zc=`awk '{ total += $3; count++ } END { print total/count }' $centroid_txt`
worldLoc="$xc $yc $zc"	
fi



default_opts="--hideCursor --size ${sx} ${sy} --neuroOrientation --scene ortho --worldLoc $worldLoc"


cmd="fsleyes render $default_opts $slice_opts --outfile $out $anat $anat_opts $seg_cmd"
echo "Final command: "

echo xvfb-run -s "-screen 0 ${sx}x${sy}x24"  $cmd
xvfb-run -s "-screen 0 ${sx}x${sy}x24"  $cmd 

