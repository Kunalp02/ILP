# search customers by account numbers 222635 and 180607
awk -F, '$1 == 22635 || $1 == 180607' customer_data.txt