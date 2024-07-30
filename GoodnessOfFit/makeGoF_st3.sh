#!/bin/bash

channels=("SL" "DL" "FH")
years=("2015" "2016" "2017" "2018")

for channel in "${channels[@]}"; do
    # Loop over each year
    for year in "${years[@]}"; do

        cd "${channel}_${year}"

        workspace="workspace_${channel}_${year}.root"
        log_file="GoF_st3_${channel}_${year}.log"

        echo "Running GoodnessOfFit for $channel $year..."

        combineTool.py -M CollectGoodnessOfFit --input higgsCombine.goodnessOfFit_data.GoodnessOfFit.mH125.38.root higgsCombine.goodnessOfFit_toys.GoodnessOfFit.mH125.38.101.root -m 125.38 -o gof.json >& "$log_file" &

        cd - > /dev/null 2>&1

        while [ $(jobs -p | wc -l) -ge 4 ]; do
            sleep 1
        done
    done
done

wait

echo "All processes completed."