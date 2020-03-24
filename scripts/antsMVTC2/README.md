# antsMVTC2 modifications for Graham

* see `snsx32/scripts/antsMVTC2`

## Details

Pulled antsMultivariateTemplateConstruction.sh from https://github.com/ANTsX/ANTs.git on 20180514.
Stable version (Note: last modification to script was 9 months prior).

## Parameter Modifications

* Important parameters that can be adjusted with flags:
  * `WALLTIME="20:00:00"`
  * `MEMORY="8gb"` --> `"16gb"` preferably
* Necessary script modifications
  * `sleep 0.5` --> `sleep 2.0`
  * `--cpus-per-task=1` --> change to 16 or 32 (number of cores) for huge speed boost per deformable registration
  * (i.e., 1 core:~9h, 8 core:1h31m, 32 core:TBD)

## Future Work

* Work in progress: `antsMultivariateTemplateConstruction2_graham_joblistSubmit.sh`
* in order to use antsMVTC2 on Graham and follow scheduling policy, would likely need to reimplement using joblists
* current problem is to modularize the functionality of the parent script that handles image averaging between iterations
* ideally BIDS dataset as input; output template

