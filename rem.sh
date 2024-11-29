#!/bin/bash
file="(file.csv)"
if [ ! -f file ]; 
then 
	echo "file does not exist"
fi

#time_to_subtract="${input_time}:00"

# Subtract 30 minutes using the date command

while IFS=, -r read time email task;
do
	tim=$time
tsk=$(grep ^task= file | cut -d '' -f2)
adjusted_time=$(date -d "$time_to_subtract - 30 minutes" +"%H:%M"
echo "at"$adjusted_time "you have" $tsk 
done


