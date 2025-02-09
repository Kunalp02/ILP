#!/bin/bash

# MySQL credentials
MYSQL_USER="root"
MYSQL_PASS="root"
MYSQL_DB="unix"

# Check MySQL connection
mysql -u "$MYSQL_USER" -p"$MYSQL_PASS" "$MYSQL_DB" -e "SELECT 1;" > /dev/null 2>&1

if [ $? -eq 0 ]; then
  echo "MySQL connection successful!"
else
  echo "MySQL connection failed!"
fi
