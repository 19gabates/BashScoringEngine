#!/bin/bash

scoring_script="./scoring.sh"
# Define text colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

countdown() {
    seconds=$1

    for ((i = seconds; i >= 1; i--)); do
        echo -n "$i"
        sleep 1

        if [ $i -gt 1 ]; then
            echo -n "....."
        fi
    done

    echo ""
}

view_dashboard() {
    ./view_dashboard.sh
}

view_stats() {
    ./stat.sh
}

# Set the countdown duration
duration=5


while true; do
    echo -e "\033c"
    echo -e "${YELLOW}Welcome to the Scoring Engine. What would you like to do?${NC}"
    echo -e "${BLUE}1.${NC} ${GREEN}IP Menu${NC}"
    echo -e "${BLUE}2.${NC} ${GREEN}Start scoring${NC}"
    echo -e "${BLUE}3.${NC} ${YELLOW}View Dashboard${NC}"
    echo -e "${BLUE}4.${NC} ${RED}Stop Scoring${NC}"
    echo -e "${BLUE}5.${NC} ${RED}Reset Menu${NC}"
    echo -e "${BLUE}6.${NC} ${YELLOW}View Stats${NC}"
    echo -e "${RED}7. Exit${NC}"

    read -p "Enter your choice (1-7): " choice

    case $choice in
        1)
            # IP Menu

            echo -e "\033c"
            echo -e "Please select what you would like do"
            echo -e "${GREEN}1. Add an IP to the list${NC}"
            echo -e "${RED}2. Remove an IP from the list${NC}"
            echo -e "(Press enter to exit)"

            read -p "Enter your choice (1-2):" ip_choice

            case $ip_choice in
                1)
                    echo -e "\033c"
                    if [ -s ip_addr_list.txt ]; then
                        echo "Current IPs in ip_addr_list.txt:"
                        cat -n ip_addr_list.txt
                    else
                        echo "ip_addr_list.txt is empty."
                    fi

                    read -p "Enter the IP address to be scored: " ip

                    # Check if the entered IP is not empty
                    if [ -n "$ip" ]; then
                        echo "$ip" >> ip_addr_list.txt
                        echo "IP address added to ip_addr_list.txt"
                    else
                        echo "No IP address entered. No entry made in ip_addr_list.txt."
                    fi
                    ;;
                2)
                    echo -e "\033c"
                    if [ -s ip_addr_list.txt ]; then
                        echo "IP addresses in ip_addr_list.txt:"
                        cat -n ip_addr_list.txt
                        read -p "Enter the line number of the IP to remove: " line_number

                        # Check if the entered line number is not empty
                        if [ -n "$line_number" ]; then
                            sed -i "${line_number}d" ip_addr_list.txt
                            echo "IP address removed from ip_addr_list.txt"
                        else
                            echo "No line number entered. No IP address removed from ip_addr_list.txt."
                        fi
                    else
                        echo "ip_addr_list.txt is empty. No IP addresses to remove."
                    fi
                    ;;
                *)
                    echo "Invalid choice. Please enter 1, 2"
                    ;;
            esac
            ;;
        2)
            # Start Scoring
            $scoring_script &
            pid=$(echo $!)
            echo "Started Scoring script with PID: $pid"
            sleep 3
            ;;
        3)
            # View Dashboard
            view_dashboard
            ;;
        4)
            # Stop Scoring
            tempPID=$(ps aux | grep ./scoring.sh | head -n 1 | awk '{print $2}')
            kill "$tempPID"
            sleep 3
            ;;
        5)
            # Reset
            echo -e "\033c"
            echo -e "Please select what you would like to reset."
            echo -e "${RED}1. Reset Current Scores"
            echo -e "2. Reset IP Address List Scores"
            echo -e "3. Reset Both${NC}"
            echo -e "(Press enter to exit)"

            read -p "Enter your choice (1-3):" reset_choice

            case $reset_choice in
                1)
                    echo -e "Reseting Current Scores."
                    countdown $duration
                    rm current_scores.txt
                    ;;
                2)
                    echo -e "Reseting IP Address List."
                    countdown $duration
                    rm ip_addr_list.txt
                    ;;
                3)
                    echo -e "Reseting both Current Scores and IP Address List."
                    countdown $duration
                    rm current_scores.txt
                    rm ip_addr_list.txt
                    ;;
                *)
                    echo "Invalid choice. Please enter 1, 2, or 3."
                    ;;
            esac
            ;;

        6)
            # View Stats
            echo -e "\033c"
            view_stats
            read -p "Press enter to close" close
            ;;
        7)
            # Exit
            echo "Exiting the script. Goodbye!"
            sleep 1
            echo -e "\033c"
            exit 0
            ;;
        *)
            echo "Invalid choice. Please enter a number between 1 and 6."
            ;;
    esac
done
