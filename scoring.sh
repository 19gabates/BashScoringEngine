#!/bin/bash

# Configuration
WebsiteScore=0            # Initialize Website score
FTPScore=0                # Initialize FTP score
SSHScore=0                # Initialize SSH score
correct_website_info="<title>Boostrap example</title>"  # Expected website content

# Color Constants
SUCCESS=$(echo -e "\e[32mSuccess\e[0m")  # Green success text
FAILURE=$(echo -e "\e[31mFailure\e[0m")  # Red failure text

# Function to check website
check_website() {
    webpage_content=$(curl -s http://"$ScoringIP")
    info_check=$(echo "$webpage_content" | grep -oP "$correct_website_info")

    if nc -zv "$ScoringIP" 80 2>&1 | grep -q "succeeded" && [ $(curl -s -o /dev/null -w "%{http_code}" http://"$ScoringIP") -eq 200 ]; then
        if [ "$info_check" == "$correct_website_info" ]; then
            score_check_website="$SUCCESS"
        else
            score_check_website="$FAILURE"
        fi
    else
        score_check_website="$FAILURE"
    fi
}

# Function to check FTP
check_ftp() {
    if nc -zv "$ScoringIP" 21 2>&1 | grep -q "succeeded"; then
        ((FTPScore++))  # Increment FTP score on success
        score_check_ftp="$SUCCESS"
    else
        score_check_ftp="$FAILURE"
    fi
}

# Function to check SSH
check_ssh() {
    if nc -zv "$ScoringIP" 22 2>&1 | grep -q "succeeded"; then
        ((SSHScore++))  # Increment SSH score on success
        score_check_ssh="$SUCCESS"
    else
        score_check_ssh="$FAILURE"
    fi
}

# Infinite loop to continuously check scores for IPs in the list
while true; do
    while IFS= read -r ScoringIP; do
        check_ssh "$ScoringIP"        # Check SSH for the current IP
        check_ftp "$ScoringIP"        # Check FTP for the current IP
        check_website "$ScoringIP"    # Check website for the current IP

        # Append scores to the current_scores.txt file with timestamp
        echo "$(date '+%Y-%m-%d %H:%M:%S') - SSH $ScoringIP: $score_check_ssh" >> current_scores.txt
        echo "$(date '+%Y-%m-%d %H:%M:%S') - FTP $ScoringIP: $score_check_ftp" >> current_scores.txt
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Website $ScoringIP: $score_check_website" >> current_scores.txt
    done < ip_addr_list.txt  # Read IP addresses from the ip_addr_list.txt file
    sleep 30  # Pause for 30 seconds before checking scores again
done
