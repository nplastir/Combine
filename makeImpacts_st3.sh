#!/bin/bash

ulimit -s unlimited

years=("2016" "2017" "2018")
channels=("DL" "SL" "FH")

for year in "${years[@]}"; do

    for channel in "${channels[@]}"; do

        cd "${year}"/"${channel}"

        log_file="Impacts_st3_${channel}_${year}.log"

        echo "Running Impacts for $channel $year..."

        if [[ "$channel" == "FH" ]]; then

            combineTool.py -d ttHcc_${channel}_${year}.root -M Impacts -m 125.38 --cminDefaultMinimizerStrategy 0 --X-rtd MINIMIZER_MaxCalls=999999999  --cminDefaultMinimizerTolerance 0.1 --cminPreScan --cminPreFit 1 -n _nominal_obs_impacts    --setParameterRanges rgx{SF_norm_.*}=-3.,3.:rgx{rate_ttZbb.*}=-5.,5.:rgx{rate_ttZcc.*}=-5.,5.:rgx{rate_ttHbb.*}=-3.,3.:rgx{rate_ttHcc.*}=-40.,40. --redefineSignalPOIs SF_norm_tt_cc_FH_${year},SF_norm_tt_cj_FH_${year},SF_norm_tt_bb_FH_${year},SF_norm_tt_bj_FH_${year},SF_norm_tt_lf_FH_${year} -o higgsCombine_nominal_obs_impacts.Impacts.mH125p38.json >& "$log_file" & "$log_file" &
        else
            combineTool.py -d ttHcc_${channel}_${year}.root -M Impacts -m 125.38 --cminDefaultMinimizerStrategy 0 --X-rtd MINIMIZER_MaxCalls=999999999  --cminDefaultMinimizerTolerance 0.1 --cminPreScan --cminPreFit 1 -n _nominal_obs_impacts    --setParameterRanges rgx{SF_norm_.*}=-3.,3.:rgx{rate_ttZbb.*}=-5.,5.:rgx{rate_ttZcc.*}=-5.,5.:rgx{rate_ttHbb.*}=-3.,3.:rgx{rate_ttHcc.*}=-40.,40. --redefineSignalPOIs SF_norm_tt_cc_${year},SF_norm_tt_cj_${year},SF_norm_tt_bb_${year},SF_norm_tt_bj_${year},SF_norm_tt_lf_${year} -o higgsCombine_nominal_obs_impacts.Impacts.mH125p38.json >& "$log_file" &

        fi

        # --setParameters rgx{SF_norm_.*}=1., rgx{tt.*}=1
        cd - > /dev/null 2>&1

        while [ $(jobs -p | wc -l) -ge 2 ]; do
            sleep 1
        done

    done
done

wait

echo "All processes completed."


