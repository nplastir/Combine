#!/bin/bash

channels=("SL" "DL" "FH")
years=("2015" "2016" "2017" "2018")

for channel in "${channels[@]}"; do
    # Loop over each year
    for year in "${years[@]}"; do

        cd "${channel}_${year}"

        workspace="workspace_${channel}_${year}.root"

        echo "Creating Impact plots for $channel $year..."

        plotImpacts.py -i higgsCombine_nominal_obs_impacts.Impacts.mH125p38.json -o higgsCombine_nominal_obs_impacts.Impacts.mH125p38_SF_norm_tt_cc --POI SF_norm_tt_cc

        plotImpacts.py -i higgsCombine_nominal_obs_impacts.Impacts.mH125p38.json -o higgsCombine_nominal_obs_impacts.Impacts.mH125p38_SF_norm_tt_cj --POI SF_norm_tt_cj

        plotImpacts.py -i higgsCombine_nominal_obs_impacts.Impacts.mH125p38.json -o higgsCombine_nominal_obs_impacts.Impacts.mH125p38_SF_norm_tt_bb --POI SF_norm_tt_bb4FS

        plotImpacts.py -i higgsCombine_nominal_obs_impacts.Impacts.mH125p38.json -o higgsCombine_nominal_obs_impacts.Impacts.mH125p38_SF_norm_tt_bj --POI SF_norm_tt_bj4FS

        plotImpacts.py -i higgsCombine_nominal_obs_impacts.Impacts.mH125p38.json -o higgsCombine_nominal_obs_impacts.Impacts.mH125p38_SF_norm_tt_lf --POI SF_norm_tt_lf

        cd - > /dev/null 2>&1

        while [ $(jobs -p | wc -l) -ge 4 ]; do 
            sleep 1
        done
    done
done

wait

echo "All processes completed."