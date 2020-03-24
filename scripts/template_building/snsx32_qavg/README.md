# Order of operations (although they can essentially be run in parallel)
snsx32_qavg_T1w.sh*
snsx32_qavg_T1map.sh*

# T2 space
# first run to create initial template with poor normalization
snsx32_qavg_T2space_orig.sh*
# use average from first step to create new normalized version
snsx32_qavg_T2space.sh*
