#!/bin/bash

file="task.csv"

if [ ! -f "$file" ]; then
    echo "File does not exist"
    exit 1
fi

while IFS=, read -r time email task; do
    if [[ "$time" == "time" || -z "$time" ]]; then
        continue
    fi
#date -d "30 minutes ago" "+%H:%M:%S"
    adjusted_time=$(date -d "$time - 30 M" "+%H%M")
    if [ $? -ne 0 ]; then
        echo "Error in time format for line: $time, $email, $task"
        continue
    fi

    echo "At $adjusted_time, you have '$task' (Original time: $time) for email: $email"
done < "$file"

