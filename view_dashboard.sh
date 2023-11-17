#!/bin/bash

run_case_sh() {
    echo "Ctrl+C pressed, running case.sh"
    ./case.sh
    exit 0
}

# Set up trap to run the function on Ctrl+C
trap run_case_sh SIGINT

while true; do
    echo -e "\033c"

    echo -e "+---------------------------------------------------------------------------+"
    printf "|%-13s | %-14s |%20s |%20s |\n" "Service" "IP Address" "Time of Last Check" "Success/Failure"


    while IFS= read -r ScoringIP; do
        Website_Log=$(grep "$ScoringIP" current_scores.txt | tail -n 1 | head -n 1)
        FTP_Log=$(grep "$ScoringIP" current_scores.txt | tail -n 2 | head -n 1)
        SSH_Log=$(grep "$ScoringIP" current_scores.txt | tail -n 3 | head -n 1)

        time=$(echo "$FTP_Log" | awk {'print $2'})

        Website_Output=$(echo "$Website_Log" | awk {'print $6'})
        FTP_Output=$(echo "$FTP_Log" | awk {'print $6'})
        SSH_Output=$(echo "$SSH_Log" | awk {'print $6'})

        echo -e "+--------------+----------------+---------------------+---------------------+"
        printf "|%-13s | %-14s |%20s |%29s |\n" "Website" "$ScoringIP" "$time" "$Website_Output"
        echo -e "+--------------+----------------+---------------------+---------------------+"
        printf "|%-13s | %-14s |%20s |%29s |\n" "FTP" "$ScoringIP" "$time" "$FTP_Output"
        echo -e "+--------------+----------------+---------------------+---------------------+"
        printf "|%-13s | %-14s |%20s |%29s |\n" "SSH" "$ScoringIP" "$time" "$SSH_Output"
    done < ip_addr_list.txt

    echo -e "+---------------------------------------------------------------------------+"
    echo "(Press Ctrl+C to Exit)"
    sleep 10
done