#!/bin/bash

# Define the CSV file
CSV_FILE="100Records.csv"

# Check if the file exists
if [[ ! -f "$CSV_FILE" ]]; then
    echo "File not found!"
    exit 1
fi
format_credit_limit() {
    # Format number with commas and append " USD"
    echo "$1" | awk '{printf "$%'\''d USD\n", $0}'
}
# Function to convert expiry date (MM/YYYY) to YYYYMM
convert_expiry_date() {
    IFS=/ read -r month year <<< "$1"
    echo "$year$month"
}

# Get the current date in YYYYMM format
current_date=$(date +%Y%m)

while IFS=, read -r card_type_code card_type_full_name issuing_bank card_number card_holder_name cvv issue_date expiry_date billing_date card_pin credit_limit
do
    # Create directories based on Card Type Full Name and Issuing Bank
    mkdir -p "$card_type_full_name/$issuing_bank"

    # Format the expiry date to YYYYMM
    expiry_date_formatted=$(convert_expiry_date "$expiry_date")

    # Determine if the card is active or expired
    if [[ "$expiry_date_formatted" -ge "$current_date" ]]; then
        status="active"
    else
        status="expired"
    fi

     # Format the credit limit
    formatted_credit_limit=$(format_credit_limit "$credit_limit")

    # Create the file with the appropriate name and content
    file_name="$card_type_full_name/$issuing_bank/$card_number.$status"
    {
        echo "Card Type Code: $card_type_code"
        echo "Card Type Full Name: $card_type_full_name"
        echo "Issuing Bank: $issuing_bank"
        echo "Card Number: $card_number"
        echo "Card Holder's Name: $card_holder_name"
        echo "CVV/CVV2: $cvv"
        echo "Issue Date: $issue_date"
        echo "Expiry Date: $expiry_date"
        echo "Billing Date: $billing_date"
        echo "Card PIN: $card_pin"
        echo "Credit Limit: $formatted_credit_limit"
    } > "$CSV_FILE"
done
