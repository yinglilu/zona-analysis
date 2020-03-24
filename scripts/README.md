# SNSX32:

* Step 1: template building for control subjects (healthy participants)

## Background

* location of BIDS dataset: `/project/6007967/cfmm-bids/Khan/SNSX_7T/`
* location of (optimized) grad corrected BIDS dataset: `/project/6007967/cfmm-bids/Khan/SNSX_7T/derivatives/gradcorrect_0.0.1h/` (NOTE: this is our starting point for template creation)

## Create .csv files

```
readlink -f ~/projects/rrg-akhanf/
find ~/projects/rrg-akhanf/cfmm-bids/Khan/SNSX_7T/derivatives/gradcorrect/ -name '*MP2RAGE*_T1w.nii.gz' | sort >& snsx32_T1w_gradcorrected.csv
find ~/projects/rrg-akhanf/cfmm-bids/Khan/SNSX_7T/derivatives/gradcorrect/ -name '*SPACE*_T2w.nii.gz' | sort >& snsx32_T2w_gradcorrected.csv
```

## Summary of Steps

* DICOM SERVER --> BIDS
* gradunwarp
* preprocessing of datasets (MP2RAGE, SPACE):
  * https://github.com/khanlab/mp2rage_correction for MP2RAGE + SA2RAGE correction
  * https://github.com/khanlab/prepT2space for T2SPACE preprocessing
* template building: see `template_building`

## Template Building: Whole Brain Full Resolution

* Goal: accurate global registration between all included subjects
* used T1w scans alone
* antsMVTC2 with some optimizations for running on graham (code available)
* initialized with rigid body registration to MNI2009b
* followed by 10 iterations of affine + deformable registration (antsMVTC2)

