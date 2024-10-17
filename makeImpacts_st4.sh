#!/bin/bash

ulimit -s unlimited

years=("2016" "2017" "2018")
channels=("DL" "SL" "FH")

for year in "${years[@]}"; do

    for channel in "${channels[@]}"; do

        cd "${year}"/"${channel}"

        log_file="Impacts_st3_${channel}_${year}.log"

        echo "Creating Impact plots for $channel $year..."

        if [[ "$channel" == "FH" ]]; then

            plotImpacts.py -i higgsCombine_nominal_obs_impacts.Impacts.mH125p38.json -o higgsCombine_nominal_obs_impacts.Impacts.mH125p38_SF_norm_tt_cc --POI SF_norm_tt_cc_FH_${year}

            plotImpacts.py -i higgsCombine_nominal_obs_impacts.Impacts.mH125p38.json -o higgsCombine_nominal_obs_impacts.Impacts.mH125p38_SF_norm_tt_cj --POI SF_norm_tt_cj_FH_${year}

            plotImpacts.py -i higgsCombine_nominal_obs_impacts.Impacts.mH125p38.json -o higgsCombine_nominal_obs_impacts.Impacts.mH125p38_SF_norm_tt_bb --POI SF_norm_tt_bb_FH_${year}

            plotImpacts.py -i higgsCombine_nominal_obs_impacts.Impacts.mH125p38.json -o higgsCombine_nominal_obs_impacts.Impacts.mH125p38_SF_norm_tt_bj --POI SF_norm_tt_bj_FH_${year}

            plotImpacts.py -i higgsCombine_nominal_obs_impacts.Impacts.mH125p38.json -o higgsCombine_nominal_obs_impacts.Impacts.mH125p38_SF_norm_tt_lf --POI SF_norm_tt_lf_FH_${year}

        else
            plotImpacts.py -i higgsCombine_nominal_obs_impacts.Impacts.mH125p38.json -o higgsCombine_nominal_obs_impacts.Impacts.mH125p38_SF_norm_tt_cc --POI SF_norm_tt_cc_${year}

            plotImpacts.py -i higgsCombine_nominal_obs_impacts.Impacts.mH125p38.json -o higgsCombine_nominal_obs_impacts.Impacts.mH125p38_SF_norm_tt_cj --POI SF_norm_tt_cj_${year}

            plotImpacts.py -i higgsCombine_nominal_obs_impacts.Impacts.mH125p38.json -o higgsCombine_nominal_obs_impacts.Impacts.mH125p38_SF_norm_tt_bb --POI SF_norm_tt_bb_${year}

            plotImpacts.py -i higgsCombine_nominal_obs_impacts.Impacts.mH125p38.json -o higgsCombine_nominal_obs_impacts.Impacts.mH125p38_SF_norm_tt_bj --POI SF_norm_tt_bj_${year}

            plotImpacts.py -i higgsCombine_nominal_obs_impacts.Impacts.mH125p38.json -o higgsCombine_nominal_obs_impacts.Impacts.mH125p38_SF_norm_tt_lf --POI SF_norm_tt_lf_${year}

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


