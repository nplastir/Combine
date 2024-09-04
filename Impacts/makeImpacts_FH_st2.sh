#!/bin/bash

# channels=("SL" "DL" "FH")
channels=("FH")
years=("2015" "2016" "2017" "2018")

for channel in "${channels[@]}"; do
    # Loop over each year
    for year in "${years[@]}"; do

        cd "${channel}_${year}"

        workspace="workspace_${channel}_${year}.root"
        log_file="Impacts_st2_${channel}_${year}.log"

        echo "Running Impacts for $channel $year..."

        combineTool.py -d $workspace -M Impacts -m 125.38 --cminDefaultMinimizerStrategy 0 --X-rtd MINIMIZER_MaxCalls=999999999 --cminDefaultMinimizerTolerance 0.1 --cminPreScan --cminPreFit 1 -n _nominal_obs_impacts --setParameters rgx{SF_norm_.*}=1.,rgx{rate_tt.*}=1.,rgx{mask_.*_SR.*}=1 --setParameterRanges rgx{SF_norm_.*}=-3.,3.:rgx{rate_ttZbb.*}=-5.,5.:rgx{rate_ttZcc.*}=-5.,5.:rgx{rate_ttHbb.*}=-3.,3.:rgx{rate_ttHcc.*}=-40.,40. --redefineSignalPOIs SF_norm_tt_cc_FH,SF_norm_tt_cj_FH,SF_norm_tt_bb4FS_FH,SF_norm_tt_bj4FS_FH,SF_norm_tt_lf_FH  --doFits --parallel 10 >& "$log_file" &

        cd - > /dev/null 2>&1

        while [ $(jobs -p | wc -l) -ge 1 ]; do 
            sleep 1
        done
    done
done

wait

echo "All processes completed."