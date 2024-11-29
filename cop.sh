#!/bin/bash

# Specify the input file
file="task.csv"

# Check if the file exists
if [ ! -f "$file" ]; then
    echo "File does not exist"
    exit 1
fi

# Loop through each line in the file
while IFS=',' read -r time email task; do
    # Skip header or invalid lines
    if [[ "$time" == "time" || -z "$time" ]]; then
        continue
    fi

    # Trim spaces from fields
    time=$(echo "$time" | xargs)
    email=$(echo "$email" | xargs)
    task=$(echo "$task" | xargs)

    # Calculate 30 minutes earlier
    adjusted_time=$(date -d "$time - 30 minutes" +"%H:%M" 2>/dev/null)
    
    # Check if the date calculation was successful
    if [ $? -ne 0 ]; then
        echo "Error in time format for line: $time, $email, $task"
        continue
    fi

    # Display the message
    echo "At $adjusted_time, you have '$task' (Original time: $time) for email: $email"
done < "$file"


