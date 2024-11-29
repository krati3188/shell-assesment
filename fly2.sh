
#!/bin/bash

declare -A users
while IFS=',' read -r time user from to status; do
    if [[ "$user" == "user" || -z "$user" ]]; then
        continue
    fi
    user=$(echo "$user" | xargs)
    status=$(echo "$status" | xargs)

    if [[ "$user" == "user" || -z "$user" ]]; then
        continue
    fi
    if [[ -z "${users["$user"]}" ]]; then
        users["$user"]=0
    fi

    if [[ "$status" == "booked" ]]; then
        users["$user"]=$((users["$user"] + 1))
    elif [[ "$status" == "cancelled" ]]; then
        users["$user"]=$((users["$user"] - 1))
    fi
done < flight.csv

echo "Contents of the map:"
for key in "${!users[@]}"; do
    echo "$key=${users[$key]}"
done

