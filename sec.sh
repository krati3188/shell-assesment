#!/bin/bash

# Display free memory
echo "Displaying free spaces:"
free -m
echo "---------------------------------"

# Display disk spaces
echo "Displaying disk spaces and checking for disks with usage > 50%:"
df -h

# Save disk space information to a CSV file
df -h > abc.csv

# Create a file to store alert messages
alert_file="notification.txt">> "$alert_file"  # Clear the file if it already exists

# Check disk usage and generate alert messages for usage > 50%
while IFS= read -r Use%;
do
      if [ Use% -gt 50 ]
        echo "$alert_message" >> "$alert_file"
    fi
done < <(df -h)

# Display the generated alert messages
echo "Alert messages generated in $alert_file"
cat "$alert_file"

