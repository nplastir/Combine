#!/bin/bash

ulimit -s unlimited

years=("2016APV" "2016" "2017" "2018")
channels=("DL" "SL" "FH")

for year in "${years[@]}"; do

    for channel in "${channels[@]}"; do

        cd "${year}"/"${channel}"

        log_file="Impacts_st1_${channel}_${year}.log"

        echo "Running Impacts for $channel $year..."

        if [[ "$channel" == "FH" ]]; then

            combineTool.py -d ttHcc_${channel}_${year}.root -M Impacts -m 125.38 --cminDefaultMinimizerStrategy 0 --X-rtd MINIMIZER_MaxCalls=999999999 --cminDefaultMinimizerTolerance 0.1 --cminPreScan --cminPreFit 1 -n _nominal_obs_impacts  --setParameterRanges rgx{SF_norm_.*}=-3.,3.:rgx{r_Zbb.*}=-5.,5.:rgx{r_Zcc.*}=-5.,5.:rgx{r_Hbb.*}=-3.,3.:rgx{r_Hcc.*}=-40.,40. --redefineSignalPOIs SF_norm_tt_cc_FH_${year},SF_norm_tt_cj_FH_${year},SF_norm_tt_bb_FH_${year},SF_norm_tt_bj_FH_${year},SF_norm_tt_lf_FH_${year} --doInitialFit --robustFit 1 --saveFitResult --saveWorkspace --saveNLL --X-rtd REMOVE_CONSTANT_ZERO_POINT=1 >& "$log_file" &
        else
            combineTool.py -d ttHcc_${channel}_${year}.root -M Impacts -m 125.38 --cminDefaultMinimizerStrategy 0 --X-rtd MINIMIZER_MaxCalls=999999999 --cminDefaultMinimizerTolerance 0.1 --cminPreScan --cminPreFit 1 -n _nominal_obs_impacts  --setParameterRanges rgx{SF_norm_.*}=-3.,3.:rgx{r_Zbb.*}=-5.,5.:rgx{r_Zcc.*}=-5.,5.:rgx{r_Hbb.*}=-3.,3.:rgx{r_Hcc.*}=-40.,40. --redefineSignalPOIs SF_norm_tt_cc_${year},SF_norm_tt_cj_${year},SF_norm_tt_bb_${year},SF_norm_tt_bj_${year},SF_norm_tt_lf_${year} --doInitialFit --robustFit 1 --saveFitResult --saveWorkspace --saveNLL --X-rtd REMOVE_CONSTANT_ZERO_POINT=1 >& "$log_file" &

        fi
        # --setParameters rgx{SF_norm_.*}=1., rgx{tt.*}=1
        cd - > /dev/null 2>&1

        while [ $(jobs -p | wc -l) -ge 3 ]; do
            sleep 1
        done

    done
done

wait

echo "All processes completed."