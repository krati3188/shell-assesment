#!/bin/bash

# Define the CSV file with the correct path
CSV_FILE="100Records.csv"

# Check if the file exists
if [ [ ! -f "$CSV_FILE" ] ]; then
    echo "File not found"
    exit 1
fi
dt=$(date +%m%y)
while IFS=, read -r column4 column8;
do	
	col_n="$column4"
	exp="$column8"
if [ [ "$exp" -gt "$dt"] ];
then
	echo " $col_n $( is active)"
else 
	echo "$col_n $( is expired)" 
fi	
done< "$CSV_FILE"
# Read the CSV file line by line
#while IFS=, read -r column1 column2 column3
#do
 #   echo "Column 1: $column1"
  #  echo "Column 2: $column2"
   # echo "Column 3: $column3"
#done < "$CSV_FILE"
