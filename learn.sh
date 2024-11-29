#!/bin/bash

# Function to send email alert
send_alert_email() {
    local disk="$1"
    local usage="$2"
    echo "ALERT: Disk usage on $disk has exceeded 50%. Current usage: $usage%" | mail -s "Disk Usage Alert: $disk" "admin@example.com"
}

echo "Displaying free memory:"
free -m
echo "---------------------------------"

echo "Displaying disk spaces and checking for disks over 50% usage:"
df -h | while read -r line; do
    # Skip the header line
    if [[ "$line" == *"Filesystem"* ]]; then
        continue
    fi
    
    # Extract the disk usage and the disk name
    usage=$(echo "$line" | awk '{print $5}' | tr -d '%')
    disk=$(echo "$line" | awk '{print $1}')
    
    # Check if usage is a valid integer
    if [[ "$usage" =~ ^[0-9]+$ ]]; then
        if [ "$usage" -gt 50 ]; then
            send_alert_email "$disk" "$usage"
        fi
    else
        # Print a debug message if the value isn't valid
        echo "Skipping line due to invalid usage value: $line"
    fi

    # Print the line for display
    echo "$line"
done

# Save disk space info to a file
df -h > abc.csv

