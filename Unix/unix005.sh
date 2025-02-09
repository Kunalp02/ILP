#  Display the avg balance of all customers excluding joint accounts
awk -F, '$4 != "Joint" {total += $5; count++} END {print total/count}' customer_data.txt
