#!/bin/bash
 
declare -A users
while  read -r user;
do
	users["$user"]=0
done<flight.csv

#for key in "${!users[@]}"; do
 #   echo "User: $key, Status: ${users[$key]}"
#done
 
while IFS=',' read -r user status; do

    if [ "$status" == "booked" ]; then
        users["$user"]=$((users["$user"] + 1))
    else
        users["$user"]=$((users["$user"] - 1))
    fi
done < flight.csv

echo "Contents of the map:"
for key in "${!users[@]}"; do
    echo "$user=${users[$user]}"
done


