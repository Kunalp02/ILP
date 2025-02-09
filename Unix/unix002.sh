# Search customers with balance >= 30000
awk -F, '$5 >= 30000' customer_data.txt
