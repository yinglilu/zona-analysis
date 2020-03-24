#!/bin/bash
# AverageImages
# how to run on graham: regularInteractive --> neurogliaShell --> cd /project/6007967/jclau/snsx32/qmaps/
#   then: ~/GitHub/snsx32/scripts/template_building/snsx32_qmaps/snsx32_qmaps_v0.2_i09/snsx32_qmaps_v0.2_i09_AverageImages.sh
# dependency: all the other qmap scripts

# TODO: remove hardcoded paths/variable names
output_dir=/project/6007967/jclau/snsx32/qmaps/snsx32_qmaps_v0.2_i09/

########################################################################################################
########################################################################################################
### T1w
########################################################################################################
########################################################################################################

# MNI2009b space (0.5 mm)
echo AverageImages 3 $output_dir/templates/snsx32_v0.2_i09_avg_T1w.nii.gz 0 `find $output_dir/ -name '*space-template_T1w.nii.gz' | sort`
AverageImages 3 $output_dir/templates/snsx32_v0.2_i09_avg_T1w.nii.gz 0 `find $output_dir/ -name '*space-template_T1w.nii.gz' | sort`
echo ImageMath 3 $output_dir/templates/snsx32_v0.2_i09_avg_sharpened_T1w.nii.gz Sharpen $output_dir/templates/snsx32_v0.2_i09_avg_T1w.nii.gz
ImageMath 3 $output_dir/templates/snsx32_v0.2_i09_avg_sharpened_T1w.nii.gz Sharpen $output_dir/templates/snsx32_v0.2_i09_avg_T1w.nii.gz

# template in 0.7 mm
echo AverageImages 3 $output_dir/templates/snsx32_v0.2_i09_avg_T1w_700iso.nii.gz 0 `find $output_dir/ -name '*space-template_res-700iso_T1w.nii.gz' | sort`
AverageImages 3 $output_dir/templates/snsx32_v0.2_i09_avg_T1w_700iso.nii.gz 0 `find $output_dir/ -name '*space-template_res-700iso_T1w.nii.gz' | sort`
echo ImageMath 3 $output_dir/templates/snsx32_v0.2_i09_avg_sharpened_T1w_700iso.nii.gz Sharpen $output_dir/templates/snsx32_v0.2_i09_avg_T1w_700iso.nii.gz
ImageMath 3 $output_dir/templates/snsx32_v0.2_i09_avg_sharpened_T1w_700iso.nii.gz Sharpen $output_dir/templates/snsx32_v0.2_i09_avg_T1w_700iso.nii.gz

########################################################################################################
########################################################################################################
### T1map + R1map
########################################################################################################
########################################################################################################

# T1map template
# 0.5mm template
echo AverageImages 3 $output_dir/templates/snsx32_v0.2_i09_avg_T1map.nii.gz 0 `find $output_dir/ -name '*space-template_T1map.nii.gz' | sort`
AverageImages 3 $output_dir/templates/snsx32_v0.2_i09_avg_T1map.nii.gz 0 `find $output_dir/ -name '*space-template_T1map.nii.gz' | sort`
echo ImageMath 3 $output_dir/templates/snsx32_v0.2_i09_avg_sharpened_T1map.nii.gz Sharpen $output_dir/templates/snsx32_v0.2_i09_avg_T1map.nii.gz
ImageMath 3 $output_dir/templates/snsx32_v0.2_i09_avg_sharpened_T1map.nii.gz Sharpen $output_dir/templates/snsx32_v0.2_i09_avg_T1map.nii.gz
# 0.7mm template
echo AverageImages 3 $output_dir/templates/snsx32_v0.2_i09_avg_T1map_700iso.nii.gz 0 `find $output_dir/ -name '*space-template_res-700iso_T1map.nii.gz' | sort`
AverageImages 3 $output_dir/templates/snsx32_v0.2_i09_avg_T1map_700iso.nii.gz 0 `find $output_dir/ -name '*space-template_res-700iso_T1map.nii.gz' | sort`
echo ImageMath 3 $output_dir/templates/snsx32_v0.2_i09_avg_sharpened_T1map_700iso.nii.gz Sharpen $output_dir/templates/snsx32_v0.2_i09_avg_T1map_700iso.nii.gz
ImageMath 3 $output_dir/templates/snsx32_v0.2_i09_avg_sharpened_T1map_700iso.nii.gz Sharpen $output_dir/templates/snsx32_v0.2_i09_avg_T1map_700iso.nii.gz

# R1map template
# 0.5mm template
echo AverageImages 3 $output_dir/templates/snsx32_v0.2_i09_avg_R1map.nii.gz 0 `find $output_dir/ -name '*space-template_R1map.nii.gz' | sort`
AverageImages 3 $output_dir/templates/snsx32_v0.2_i09_avg_R1map.nii.gz 0 `find $output_dir/ -name '*space-template_R1map.nii.gz' | sort`
echo ImageMath 3 $output_dir/templates/snsx32_v0.2_i09_avg_sharpened_R1map.nii.gz Sharpen $output_dir/templates/snsx32_v0.2_i09_avg_R1map.nii.gz
ImageMath 3 $output_dir/templates/snsx32_v0.2_i09_avg_sharpened_R1map.nii.gz Sharpen $output_dir/templates/snsx32_v0.2_i09_avg_R1map.nii.gz
# 0.7mm template
echo AverageImages 3 $output_dir/templates/snsx32_v0.2_i09_avg_R1map_700iso.nii.gz 0 `find $output_dir/ -name '*space-template_res-700iso_R1map.nii.gz' | sort`
AverageImages 3 $output_dir/templates/snsx32_v0.2_i09_avg_R1map_700iso.nii.gz 0 `find $output_dir/ -name '*space-template_res-700iso_R1map.nii.gz' | sort`
echo ImageMath 3 $output_dir/templates/snsx32_v0.2_i09_avg_sharpened_R1map_700iso.nii.gz Sharpen $output_dir/templates/snsx32_v0.2_i09_avg_R1map_700iso.nii.gz
ImageMath 3 $output_dir/templates/snsx32_v0.2_i09_avg_sharpened_R1map_700iso.nii.gz Sharpen $output_dir/templates/snsx32_v0.2_i09_avg_R1map_700iso.nii.gz

########################################################################################################
########################################################################################################
### T2 SPACE
########################################################################################################
########################################################################################################

# MNI2009b space (0.5 mm)
echo AverageImages 3 $output_dir/templates/snsx32_v0.2_i09_avg_T2w.nii.gz 0 `find $output_dir/ -name '*space-template_T2w.nii.gz' | sort`
AverageImages 3 $output_dir/templates/snsx32_v0.2_i09_avg_T2w.nii.gz 0 `find $output_dir/ -name '*space-template_T2w.nii.gz' | sort`
echo ImageMath 3 $output_dir/templates/snsx32_v0.2_i09_avg_sharpened_T2w.nii.gz Sharpen $output_dir/templates/snsx32_v0.2_i09_avg_T2w.nii.gz
ImageMath 3 $output_dir/templates/snsx32_v0.2_i09_avg_sharpened_T2w.nii.gz Sharpen $output_dir/templates/snsx32_v0.2_i09_avg_T2w.nii.gz

# template in 0.7 mm
echo AverageImages 3 $output_dir/templates/snsx32_v0.2_i09_avg_T2w_700iso.nii.gz 0 `find $output_dir/ -name '*space-template_res-700iso_T2w.nii.gz' | sort`
AverageImages 3 $output_dir/templates/snsx32_v0.2_i09_avg_T2w_700iso.nii.gz 0 `find $output_dir/ -name '*space-template_res-700iso_T2w.nii.gz' | sort`
echo ImageMath 3 $output_dir/templates/snsx32_v0.2_i09_avg_sharpened_T2w_700iso.nii.gz Sharpen $output_dir/templates/snsx32_v0.2_i09_avg_T2w_700iso.nii.gz
ImageMath 3 $output_dir/templates/snsx32_v0.2_i09_avg_sharpened_T2w_700iso.nii.gz Sharpen $output_dir/templates/snsx32_v0.2_i09_avg_T2w_700iso.nii.gz

########################################################################################################
########################################################################################################
### GRE
########################################################################################################
########################################################################################################

# MNI2009b space (0.5 mm)
echo AverageImages 3 $output_dir/templates/snsx32_v0.2_i09_avg_R2star.nii.gz 0 `find $output_dir/ -name '*space-template_R2star.nii.gz' | sort`
AverageImages 3 $output_dir/templates/snsx32_v0.2_i09_avg_R2star.nii.gz 0 `find $output_dir/ -name '*space-template_R2star.nii.gz' | sort`
echo ImageMath 3 $output_dir/templates/snsx32_v0.2_i09_avg_sharpened_R2star.nii.gz Sharpen $output_dir/templates/snsx32_v0.2_i09_avg_R2star.nii.gz
ImageMath 3 $output_dir/templates/snsx32_v0.2_i09_avg_sharpened_R2star.nii.gz Sharpen $output_dir/templates/snsx32_v0.2_i09_avg_R2star.nii.gz

# template in 0.7 mm
echo AverageImages 3 $output_dir/templates/snsx32_v0.2_i09_avg_R2star_700iso.nii.gz 0 `find $output_dir/ -name '*space-template_res-700iso_R2star.nii.gz' | sort`
AverageImages 3 $output_dir/templates/snsx32_v0.2_i09_avg_R2star_700iso.nii.gz 0 `find $output_dir/ -name '*space-template_res-700iso_R2star.nii.gz' | sort`
echo ImageMath 3 $output_dir/templates/snsx32_v0.2_i09_avg_sharpened_R2star_700iso.nii.gz Sharpen $output_dir/templates/snsx32_v0.2_i09_avg_R2star_700iso.nii.gz
ImageMath 3 $output_dir/templates/snsx32_v0.2_i09_avg_sharpened_R2star_700iso.nii.gz Sharpen $output_dir/templates/snsx32_v0.2_i09_avg_R2star_700iso.nii.gz

# MNI2009b space (0.5 mm)
echo AverageImages 3 $output_dir/templates/snsx32_v0.2_i09_avg_QSM.nii.gz 0 `find $output_dir/ -name '*space-template_QSM.nii.gz' | sort`
AverageImages 3 $output_dir/templates/snsx32_v0.2_i09_avg_QSM.nii.gz 0 `find $output_dir/ -name '*space-template_QSM.nii.gz' | sort`
echo ImageMath 3 $output_dir/templates/snsx32_v0.2_i09_avg_sharpened_QSM.nii.gz Sharpen $output_dir/templates/snsx32_v0.2_i09_avg_QSM.nii.gz
ImageMath 3 $output_dir/templates/snsx32_v0.2_i09_avg_sharpened_QSM.nii.gz Sharpen $output_dir/templates/snsx32_v0.2_i09_avg_QSM.nii.gz

# template in 0.7 mm
echo AverageImages 3 $output_dir/templates/snsx32_v0.2_i09_avg_QSM_700iso.nii.gz 0 `find $output_dir/ -name '*space-template_res-700iso_QSM.nii.gz' | sort`
AverageImages 3 $output_dir/templates/snsx32_v0.2_i09_avg_QSM_700iso.nii.gz 0 `find $output_dir/ -name '*space-template_res-700iso_QSM.nii.gz' | sort`
echo ImageMath 3 $output_dir/templates/snsx32_v0.2_i09_avg_sharpened_QSM_700iso.nii.gz Sharpen $output_dir/templates/snsx32_v0.2_i09_avg_QSM_700iso.nii.gz
ImageMath 3 $output_dir/templates/snsx32_v0.2_i09_avg_sharpened_QSM_700iso.nii.gz Sharpen $output_dir/templates/snsx32_v0.2_i09_avg_QSM_700iso.nii.gz

########################################################################################################
########################################################################################################
### DWI
########################################################################################################
########################################################################################################

# MNI2009b space (0.5 mm)
echo AverageImages 3 $output_dir/templates/snsx32_v0.2_i09_avg_FA.nii.gz 0 `find $output_dir/ -name '*space-template_FA.nii.gz' | sort`
AverageImages 3 $output_dir/templates/snsx32_v0.2_i09_avg_FA.nii.gz 0 `find $output_dir/ -name '*space-template_FA.nii.gz' | sort`
echo ImageMath 3 $output_dir/templates/snsx32_v0.2_i09_avg_sharpened_FA.nii.gz Sharpen $output_dir/templates/snsx32_v0.2_i09_avg_FA.nii.gz
ImageMath 3 $output_dir/templates/snsx32_v0.2_i09_avg_sharpened_FA.nii.gz Sharpen $output_dir/templates/snsx32_v0.2_i09_avg_FA.nii.gz

# template in 0.7 mm
echo AverageImages 3 $output_dir/templates/snsx32_v0.2_i09_avg_FA_700iso.nii.gz 0 `find $output_dir/ -name '*space-template_res-700iso_FA.nii.gz' | sort`
AverageImages 3 $output_dir/templates/snsx32_v0.2_i09_avg_FA_700iso.nii.gz 0 `find $output_dir/ -name '*space-template_res-700iso_FA.nii.gz' | sort`
echo ImageMath 3 $output_dir/templates/snsx32_v0.2_i09_avg_sharpened_FA_700iso.nii.gz Sharpen $output_dir/templates/snsx32_v0.2_i09_avg_FA_700iso.nii.gz
ImageMath 3 $output_dir/templates/snsx32_v0.2_i09_avg_sharpened_FA_700iso.nii.gz Sharpen $output_dir/templates/snsx32_v0.2_i09_avg_FA_700iso.nii.gz

# MNI2009b space (0.5 mm)
echo AverageImages 3 $output_dir/templates/snsx32_v0.2_i09_avg_MD.nii.gz 0 `find $output_dir/ -name '*space-template_MD.nii.gz' | sort`
AverageImages 3 $output_dir/templates/snsx32_v0.2_i09_avg_MD.nii.gz 0 `find $output_dir/ -name '*space-template_MD.nii.gz' | sort`
echo ImageMath 3 $output_dir/templates/snsx32_v0.2_i09_avg_sharpened_MD.nii.gz Sharpen $output_dir/templates/snsx32_v0.2_i09_avg_MD.nii.gz
ImageMath 3 $output_dir/templates/snsx32_v0.2_i09_avg_sharpened_MD.nii.gz Sharpen $output_dir/templates/snsx32_v0.2_i09_avg_MD.nii.gz

# template in 0.7 mm
echo AverageImages 3 $output_dir/templates/snsx32_v0.2_i09_avg_MD_700iso.nii.gz 0 `find $output_dir/ -name '*space-template_res-700iso_MD.nii.gz' | sort`
AverageImages 3 $output_dir/templates/snsx32_v0.2_i09_avg_MD_700iso.nii.gz 0 `find $output_dir/ -name '*space-template_res-700iso_MD.nii.gz' | sort`
echo ImageMath 3 $output_dir/templates/snsx32_v0.2_i09_avg_sharpened_MD_700iso.nii.gz Sharpen $output_dir/templates/snsx32_v0.2_i09_avg_MD_700iso.nii.gz
ImageMath 3 $output_dir/templates/snsx32_v0.2_i09_avg_sharpened_MD_700iso.nii.gz Sharpen $output_dir/templates/snsx32_v0.2_i09_avg_MD_700iso.nii.gz

########################################################################################################
########################################################################################################
### logjac
########################################################################################################
########################################################################################################

# MNI2009b space (0.5 mm)
echo AverageImages 3 $output_dir/templates/snsx32_v0.2_i09_avg_logjac.nii.gz 0 `find $output_dir/ -name '*space-template_logjac.nii.gz' | sort`
AverageImages 3 $output_dir/templates/snsx32_v0.2_i09_avg_logjac.nii.gz 0 `find $output_dir/ -name '*space-template_logjac.nii.gz' | sort`
echo ImageMath 3 $output_dir/templates/snsx32_v0.2_i09_avg_sharpened_logjac.nii.gz Sharpen $output_dir/templates/snsx32_v0.2_i09_avg_logjac.nii.gz
ImageMath 3 $output_dir/templates/snsx32_v0.2_i09_avg_sharpened_logjac.nii.gz Sharpen $output_dir/templates/snsx32_v0.2_i09_avg_logjac.nii.gz

# template in 0.7 mm
echo AverageImages 3 $output_dir/templates/snsx32_v0.2_i09_avg_logjac_700iso.nii.gz 0 `find $output_dir/ -name '*space-template_res-700iso_logjac.nii.gz' | sort`
AverageImages 3 $output_dir/templates/snsx32_v0.2_i09_avg_logjac_700iso.nii.gz 0 `find $output_dir/ -name '*space-template_res-700iso_logjac.nii.gz' | sort`
echo ImageMath 3 $output_dir/templates/snsx32_v0.2_i09_avg_sharpened_logjac_700iso.nii.gz Sharpen $output_dir/templates/snsx32_v0.2_i09_avg_logjac_700iso.nii.gz
ImageMath 3 $output_dir/templates/snsx32_v0.2_i09_avg_sharpened_logjac_700iso.nii.gz Sharpen $output_dir/templates/snsx32_v0.2_i09_avg_logjac_700iso.nii.gz

