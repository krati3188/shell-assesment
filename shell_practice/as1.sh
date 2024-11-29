#!/bin/bash

# Check if the input CSV file is provided
if [ $# -lt 1 ]; then
    echo "Usage: $0 <csv_file>"
    exit 1
fi

# Input CSV file (provided as argument)
csv_file=$1

# Get the current month and year in MM/YYYY format for expiry date comparison
current_date=$(date +"%m/%Y")

# Function to format the Credit Limit as USD
format_credit_limit() {
    # Format number with commas and append " USD"
    echo "$1" | awk '{printf "$%0.0f USD\n", $1}' | sed ':a;s/\B[0-9]\{3\}\>/,&/;ta'
}

# Function to convert expiry date (Mon-YY) to MM/YYYY
convert_expiry_date() {
    month_map=("Jan" "Feb" "Mar" "Apr" "May" "Jun" "Jul" "Aug" "Sep" "Oct" "Nov" "Dec")
    month_str=$1
    year_str=$2
    for i in "${!month_map[@]}"; do
        if [[ "${month_map[$i]}" == "$month_str" ]]; then
            month=$(printf "%02d" $((i + 1)))
            break
        fi
    done
    echo "$month/$year_str"
}

# Check if the file exists
if [ ! -f "$csv_file" ]; then
    echo "File not found: $csv_file"
    exit 1
fi

# Read the CSV file line by line, skipping the header if present
while IFS=',' read -r card_type_code card_type_full_name issuing_bank card_number card_holder cvv issue_date expiry_date billing_date card_pin credit_limit; do
    # Skip the header line (if any)
    if [[ "$card_number" == "Card Number" ]]; then
        continue
    fi

    # Remove leading/trailing whitespaces from fields
    card_number=$(echo "$card_number" | xargs)
    expiry_date=$(echo "$expiry_date" | xargs)
    card_type_full_name=$(echo "$card_type_full_name" | xargs)
    issuing_bank=$(echo "$issuing_bank" | xargs)
    card_holder=$(echo "$card_holder" | xargs)
    credit_limit=$(echo "$credit_limit" | xargs)

    # Format credit limit as USD
    formatted_credit_limit=$(format_credit_limit "$credit_limit")

    # Extract the month and year from the expiry_date
    expiry_month=$(echo "$expiry_date" | cut -d'/' -f1)
    expiry_year=$(echo "$expiry_date" | cut -d'/' -f2)

    # Convert expiry_date and current_date to YYYYMM for numerical comparison
    expiry_date_numeric=$(printf "%04d%02d" "$expiry_year" "$expiry_month")
    current_date_numeric=$(echo "$current_date" | awk -F'/' '{printf "%04d%02d", $2, $1}')

    # Compare expiry_date with the current date
    if [[ "$expiry_date_numeric" -gt "$current_date_numeric" ]]; then
        # Card is active
        file_name="${card_number}.active"
    else
        # Card is expired
        file_name="${card_number}.expired"
    fi

    # Create directories based on Card Type Full Name and Issuing Bank
    mkdir -p "$card_type_full_name/$issuing_bank"

    # Create a file for the card and add the formatted content
    file_path="$card_type_full_name/$issuing_bank/$file_name"
    {
        echo "Card Type Code: $card_type_code"
        echo "Card Type Full Name: $card_type_full_name"
        echo "Issuing Bank: $issuing_bank"
        echo "Card Number: $card_number"
        echo "Card Holder's Name: $card_holder"
        echo "CVV/CVV2: $cvv"
        echo "Issue Date: $issue_date"
        echo "Expiry Date: $expiry_date"
        echo "Billing Date: $billing_date"
        echo "Card PIN: $card_pin"
        echo "Credit Limit: $formatted_credit_limit"
    } > "$file_path"

    echo "Created file: $file_path"
done < "$csv_file"

