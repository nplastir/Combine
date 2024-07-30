#!/bin/bash

channels=("SL" "DL" "FH")
years=("2015" "2016" "2017" "2018")

for channel in "${channels[@]}"; do
    # Loop over each year
    for year in "${years[@]}"; do

        cd "${channel}_${year}"

        workspace="workspace_${channel}_${year}.root"
        log_file="GoF_st1_${channel}_${year}.log"

        echo "Running GoodnessOfFit for $channel $year..."

        combine -d $workspace -M GoodnessOfFit --algo=saturated -m 125.38 --cminDefaultMinimizerStrategy 0 --X-rtd MINIMIZER_MaxCalls=999999999 --cminDefaultMinimizerTolerance 0.1 --cminPreScan --cminPreFit 1 --setParameters rgx{SF_norm_.*}=1.,rgx{rate_tt.*}=1.,rgx{mask_.*_SR.*}=1 --setParameterRanges rgx{SF_norm_.*}=-3.,3.:rgx{rate_ttZbb.*}=-5.,5.:rgx{rate_ttZcc.*}=-5.,5.:rgx{rate_ttHbb.*}=-3.,3.:rgx{rate_ttHcc.*}=-40.,40. -n .goodnessOfFit_data >& "$log_file" &

        cd - > /dev/null 2>&1

        while [ $(jobs -p | wc -l) -ge 4 ]; do
            sleep 1
        done
    done
done

wait

echo "All processes completed."