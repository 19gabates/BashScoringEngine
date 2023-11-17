#!/bin/bash

# Specify the path to your log file
LOG_FILE="current_scores.txt"

# Extract the timestamps from the log file
start_timestamp=$(head -n 1 "$LOG_FILE" | awk '{print $1, $2}')
end_timestamp=$(tail -n 1 "$LOG_FILE" | awk '{print $1, $2}')

# Convert timestamps to Unix timestamps for easy calculation
start_unix=$(date -d "$start_timestamp" "+%s")
end_unix=$(date -d "$end_timestamp" "+%s")

# Calculate the duration in seconds
duration_seconds=$((end_unix - start_unix))

# Convert seconds to human-readable format (HH:MM:SS)
duration_formatted=$(date -u -d @"$duration_seconds" +'%H:%M:%S')

echo "Scoring Duration: $duration_formatted"

echo -e "+--------------+----------------+---------------------+"
printf "|%-13s | %-14s |%20s |\n" "Service" "IP"  "Score"
echo -e "+--------------+----------------+---------------------+"

while IFS= read -r ScoringIP; do
    Website_Log=$(grep "Website $ScoringIP" current_scores.txt)
    FTP_Log=$(grep "FTP $ScoringIP" current_scores.txt)
    SSH_Log=$(grep "SSH $ScoringIP" current_scores.txt)

    Website_Success=$(echo "$Website_Log" | grep Success | wc -l)
    FTP_Success=$(echo "$FTP_Log" | grep Success | wc -l)
    SSH_Success=$(echo "$SSH_Log" | grep Success | wc -l)


    if [ "$Website_Success" -gt 0 ]; then
        printf "|%-13s | %-14s |%20s |\n" "Website" "$ScoringIP"  "$Website_Success"
        echo -e "+--------------+----------------+---------------------+"
    fi

    if [ "$FTP_Success" -gt 0 ]; then
        printf "|%-13s | %-14s |%20s |\n" "FTP" "$ScoringIP" "$FTP_Success"
        echo -e "+--------------+----------------+---------------------+"
    fi

    if [ "$SSH_Success" -gt 0 ]; then
        printf "|%-13s | %-14s |%20s |\n" "SSH" "$ScoringIP" "$SSH_Success"
        echo -e "+--------------+----------------+---------------------+"
    fi

done < ip_addr_list.txt
