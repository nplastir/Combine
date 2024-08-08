#!/bin/bash

channels=("SL" "DL" "FH" "ALL")
years=("2015" "2016" "2017" "2018" "FR2")

folder="/eos/user/n/nplastir/ttH/CMSSW_14_1_0_pre4/src/datacards/datacards/workspaces"

# Loop over each channel
for channel in "${channels[@]}"; do
    # Loop over each year
    for year in "${years[@]}"; do

        datacard="ttHcc_${channel}_${year}.txt"
        workspace="workspace_${channel}_${year}.root"
        log_file="${folder}/logs/makeWorkspace_${channel}_${year}.log"

        echo "Running text2workspace.py for $channel $year..."
        text2workspace.py $datacard -o $folder/$workspace -m 125.38 -P HiggsAnalysis.CombinedLimit.PhysicsModel:multiSignalModel -v 0 --channel-masks --PO 'map=.*/ttH_hbb:rate_ttHbb[1.,-10.,10.]' --PO 'map=.*/ttH_hcc:rate_ttHcc[1.,-10.,10.]' --PO 'map=.*/ttZ_zbb:rate_ttZbb[1.,-10.,10.]' --PO 'map=.*/ttZ_zcc:rate_ttZcc[1.,-10.,10.]' >& "$log_file" &

        while [ $(jobs -p | wc -l) -ge 5 ]; do
            sleep 1
        done
    done
done

wait

echo "All processes completed."