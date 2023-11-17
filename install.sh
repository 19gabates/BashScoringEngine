#!/bin/bash

# List of required commands
required_commands=("awk" "sed" "nc" "curl")

# Check if all required commands are installed
missing_commands=()
for cmd in "${required_commands[@]}"; do
    if ! command -v "$cmd" &> /dev/null; then
        missing_commands+=("$cmd")
    fi
done

if [ ${#missing_commands[@]} -eq 0 ]; then
    echo "All required commands are installed. Proceeding with the installation."
else
    # Install missing commands
    echo "Installing missing commands: ${missing_commands[@]}"
    
    # Adjust the package manager based on your distribution (apt, yum, etc.)
    # Uncomment and modify the following lines based on your package manager
    # For example, on Debian/Ubuntu systems:
    # sudo apt-get update
    # sudo apt-get install "${missing_commands[@]}"
    
    # For example, on Red Hat/Fedora systems:
    # sudo yum install "${missing_commands[@]}"
fi

# Make the scripts executable
chmod +x scoring.sh case.sh view_dashboard.sh stat.sh

echo "Installation completed."
