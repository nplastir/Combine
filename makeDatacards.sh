#!/bin/bash

years=("2016APV" "2016" "2017" "2018")
channels=("DL" "SL" "FH")

for year in "${years[@]}"; do

    for channel in "${channels[@]}"; do

        cd "${year}"/"${channel}"

        log_file="run_ttH_${year}_${channel}.log"

        echo "Running ttHcards for $channel $year"

        python3 ../../../writeTTHCards.py --split-ttbar-components --split-lepton-channels --fit-data ../../../../results/ttH_20240308_ak4puppi__nn10cats_splitTTHF_4FS_valR_midScore_useData_unblindSR_Oct2024_v7p1/Cards/$year/$channel/ >& "$log_file" &

        cd - > /dev/null 2>&1

        while [ $(jobs -p | wc -l) -ge 3 ]; do
            sleep 1
        done

    done
done

wait

echo "All processes completed."