#!/bin/bash

# Define variables
DB_USER="root"
DB_PASS="root"
DB_NAME="unix"

# Create the CustomerDetails table if it does not exist
mysql -u "$DB_USER" -p"$DB_PASS" -D "$DB_NAME" -e "
CREATE TABLE IF NOT EXISTS CustomerDetails (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    date_of_opening DATE,
    account_type VARCHAR(20),
    balance DECIMAL(10,2)
);
"

# Convert dd.mm.yy to yyyy-mm-dd manually and insert into the database
while IFS=',' read -r customer_id name date account_type balance; do
    # Skip empty lines or malformed input
    if [[ -z "$customer_id" || -z "$name" || -z "$date" || -z "$account_type" || -z "$balance" ]]; then
        echo "Skipping malformed row: $customer_id, $name, $date, $account_type, $balance"
        continue
    fi

    # Extract first and last names
    first_name=$(echo "$name" | awk '{print $1}')
    last_name=$(echo "$name" | awk '{print $2}')

    # Manually convert date format from dd.mm.yy to yyyy-mm-dd
    day=$(echo "$date" | cut -d'.' -f1)
    month=$(echo "$date" | cut -d'.' -f2)
    year=$(echo "$date" | cut -d'.' -f3)

    # Handle two-digit years (assuming 2000-2099 range)
    if [[ "$year" -lt 100 ]]; then
        year=$((2000 + 10#$year))  # Add 2000 to the year
    fi

    # Validate day and month ranges
    if [[ "$day" -gt 31 || "$month" -gt 12 || "$day" -lt 1 || "$month" -lt 1 ]]; then
        echo "Invalid date: $date. Skipping row."
        continue
    fi

    formatted_date="$year-$month-$day"

    # Normalize account type to lowercase
    account_type=$(echo "$account_type" | tr '[:upper:]' '[:lower:]')

    # Insert data into the database
    mysql -u "$DB_USER" -p"$DB_PASS" -D "$DB_NAME" -e "
        INSERT INTO CustomerDetails (customer_id, first_name, last_name, date_of_opening, account_type, balance)
        VALUES ($customer_id, '$first_name', '$last_name', '$formatted_date', '$account_type', $balance)
        ON DUPLICATE KEY UPDATE
        first_name=VALUES(first_name),
        last_name=VALUES(last_name),
        date_of_opening=VALUES(date_of_opening),
        account_type=VALUES(account_type),
        balance=VALUES(balance);
    " || echo "Error inserting row: $customer_id, $first_name, $last_name, $formatted_date, $account_type, $balance"
done < customer_data.txt

echo "Data loaded successfully!"
