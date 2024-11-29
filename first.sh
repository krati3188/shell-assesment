#!/bin/bash
# Read the CSV file line by line
while IFS=, read -r name age city
do
  # Skip the header line
  if [ "$name" != "name" ]; then
    # Create a filename based on the name field
    filename="${name}.txt"
    # Write the record to the file
    echo "Name: $name" > "$filename"
    echo "Age: $age" >> "$filename"
    echo "City: $city" >> "$filename"
  fi
done < 100 CC Records 1.csv

