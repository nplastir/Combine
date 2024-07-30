#!/bin/bash

channels=("SL" "DL" "FH")
years=("2015" "2016" "2017" "2018")

for channel in "${channels[@]}"; do
    # Loop over each year
    for year in "${years[@]}"; do

        log_file="GoF_st4_${channel}_${year}.log"

        echo "Running GoodnessOfFit for $channel $year..."

        python3 plotGoF.py --json ${channel}_${year}/gof.json --algo saturated --out ${channel}_${year} --ch $channel --y $year >& "${channel}_${year}/$log_file" &

        # python3 plotGoF_wchi2.py --json ${channel}_${year}/gof.json --algo saturated --out ${channel}_${year} --ch $channel --y $year >& "${channel}_${year}/$log_file" &
        
        #plotGof.py gof.json --statistic saturated --mass 125.0 -o gof_plot  >& "$log_file" &

        while [ $(jobs -p | wc -l) -ge 4 ]; do
            sleep 1
        done
    done
done

wait

echo "All processes completed."