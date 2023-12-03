#!/bin/bash

# Function to run case.sh on Ctrl+C
run_case_sh() {
    echo "Ctrl+C pressed, running case.sh"
    ./case.sh  # Execute the case.sh script
    exit 0     # Exit the current script
}

# Set up trap to run the function on Ctrl+C
trap run_case_sh SIGINT

while true; do
    echo -e "\033c"  # Clear the screen

    echo -e "+---------------------------------------------------------------------------+"
    printf "|%-13s | %-14s |%20s |%20s |\n" "Service" "IP Address" "Time of Last Check" "Success/Failure"

    # Loop through each IP in the list
    while IFS= read -r ScoringIP; do
        # Retrieve logs for Website, FTP, and SSH for the current IP
        Website_Log=$(grep "$ScoringIP" current_scores.txt | tail -n 1 | head -n 1)
        FTP_Log=$(grep "$ScoringIP" current_scores.txt | tail -n 2 | head -n 1)
        SSH_Log=$(grep "$ScoringIP" current_scores.txt | tail -n 3 | head -n 1)

        # Extract time of the last check
        time=$(echo "$FTP_Log" | awk {'print $2'})

        # Extract output (Success/Failure) for Website, FTP, and SSH
        Website_Output=$(echo "$Website_Log" | awk {'print $6'})
        FTP_Output=$(echo "$FTP_Log" | awk {'print $6'})
        SSH_Output=$(echo "$SSH_Log" | awk {'print $6'})

        # Display the information in a formatted table
        echo -e "+--------------+----------------+---------------------+---------------------+"
        printf "|%-13s | %-14s |%20s |%29s |\n" "Website" "$ScoringIP" "$time" "$Website_Output"
        echo -e "+--------------+----------------+---------------------+---------------------+"
        printf "|%-13s | %-14s |%20s |%29s |\n" "FTP" "$ScoringIP" "$time" "$FTP_Output"
        echo -e "+--------------+----------------+---------------------+---------------------+"
        printf "|%-13s | %-14s |%20s |%29s |\n" "SSH" "$ScoringIP" "$time" "$SSH_Output"
    done < ip_addr_list.txt  # Read IP addresses from the ip_addr_list.txt file

    echo -e "+---------------------------------------------------------------------------+"
    echo "(Press Ctrl+C to Exit)"
    sleep 10  # Pause for 10 seconds before displaying the information again
done
