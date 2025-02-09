#!/bin/bash

# Define variables
DB_USER="root"
DB_PASS="root"
DB_NAME="unix"
OUTPUT_FILE="output.txt"

# Fetch data from the database and write to a file
mysql -u "$DB_USER" -p"$DB_PASS" -D "$DB_NAME" -Bse "
SELECT CONCAT(
    customer_id, ', ',
    first_name, ' ',
    last_name, ', ',
    DATE_FORMAT(date_of_opening, '%d.%m.%y'), ', ',
    account_type, ', ',
    balance
) AS row_data FROM CustomerDetails;" > "$OUTPUT_FILE"

# Check if the file was created successfully
if [[ -f "$OUTPUT_FILE" ]]; then
    echo "Data fetched successfully and saved to $OUTPUT_FILE"
else
    echo "Failed to fetch data or save to file."
fi
