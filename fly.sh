#!/bin/bash

declare -A users

# Process the CSV file
while IFS=',' read -r time user from to status; do
    # Skip the header line or invalid entries
    if [[ "$user" == "user" || -z "$user" ]]; then
        continue
    fi

    # Initialize user in the map if not already present
    if [[ -z "${users["$user"]}" ]]; then
        users["$user"]=0
    fi

    # Update status based on "booked" or "cancelled"
    if [[ "$status" == *"booked"* ]]; then
        users["$user"]=$((users["$user"] + 1))
    elif [[ "$status" == *"cancelled"* ]]; then
        users["$user"]=$((users["$user"] - 1))
    fi
done < flight.csv

# Print the contents of the map
echo "Contents of the map:"
for key in "${!users[@]}"; do
    echo "$key=${users[$key]}"
done

