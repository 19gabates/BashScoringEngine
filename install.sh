#!/bin/bash

# Install necessary commands
sudo apt-get update
sudo apt-get install -y curl

# Check if curl is installed successfully
if command -v curl &> /dev/null; then
    echo "curl is installed successfully."
else
    echo "Error: Failed to install curl."
    exit 1
fi

# Create necessary files
touch ip_addr_list.txt
touch current_scores.txt

# Make scripts executable
chmod +x scoring.sh
chmod +x view_dashboard.sh
chmod +x stat.sh

# Display completion message
echo "Installation completed successfully."
