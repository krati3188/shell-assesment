#!/bin/bash

echo "Displaying free spaces:"
free -m
echo "---------------------------------"

echo "Displaying disk spaces and checking for disks with usage > 50%:"
df -h

df -h > abc.csv

alert_file="notification.txt"
>> "usage is greater than 50% please delete some files" 

df -h | awk 'NR > 1 && $5 + 0 > 10 {print "ALERT: Disk "$1" is at "$5" usage"}' >> "$alert_file"


echo "if any disk's usage is >50% alert messages generated in $alert_file"
cat "$alert_file"
echo "largest 10 files"
echo "---------------------------------"
du -a | sort -rn | head -10
