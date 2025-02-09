#  Display the total balance of customers with a Joint account 
awk -F, '$4 == "Joint" {total += $5} END {print total}' customer_data.txt
