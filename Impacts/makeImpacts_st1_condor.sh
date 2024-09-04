#!/bin/bash

channels=("SL" "DL" "FH")
years=("FR2")

for channel in "${channels[@]}"; do
    # Loop over each year
    for year in "${years[@]}"; do

        cd "${channel}_${year}"

        workspace="workspace_${channel}_${year}.root"
        log_file="Impacts_st1_${channel}_${year}.log"

        echo "Running Impacts for $channel $year..."

        combineTool.py -d $workspace -M Impacts -m 125.38 --cminDefaultMinimizerStrategy 0 --X-rtd MINIMIZER_MaxCalls=999999999 --cminDefaultMinimizerTolerance 0.1 --cminPreScan --cminPreFit 1 -n _nominal_obs_impacts --setParameters rgx{SF_norm_.*}=1.,rgx{rate_tt.*}=1.,rgx{mask_.*_SR.*}=1 --setParameterRanges rgx{SF_norm_.*}=-3.,3.:rgx{rate_ttZbb.*}=-5.,5.:rgx{rate_ttZcc.*}=-5.,5.:rgx{rate_ttHbb.*}=-3.,3.:rgx{rate_ttHcc.*}=-40.,40. --redefineSignalPOIs SF_norm_tt_cc,SF_norm_tt_cj,SF_norm_tt_bb4FS,SF_norm_tt_bj4FS,SF_norm_tt_lf --doInitialFit --robustFit 1 --saveFitResult --saveWorkspace --saveNLL --X-rtd REMOVE_CONSTANT_ZERO_POINT=1 --job-mode condor --task-name ${channel}_${year} --sub-opts='+JobFlavour="workday" \n request_cpus=8' >& "$log_file" &

        cd - > /dev/null 2>&1

        while [ $(jobs -p | wc -l) -ge 4 ]; do
            sleep 1
        done
    done
done

wait

echo "All processes completed."