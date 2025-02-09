create database bank;
use bank;

show tables;

create table Users(
	id INT AUTO_INCREMENT PRIMARY KEY,
    user_profile_id INT,
    customer_ssn_id VARCHAR(20),
	emp_id VARCHAR(20),
    role ENUM('Customer', 'Employee', 'Admin'),
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

create table UserProfiles(
	id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone_no VARCHAR(15) ,
    address TEXT,
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE
);

CREATE TABLE LoanRequests(
	id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    performed_by_id INT NULL,
    loan_amount DECIMAL(10, 2) NOT NULL,
    loan_type ENUM('Personal', 'Mortage', 'Auto') NOT NULL,
    status ENUM('Pending', 'Approved', 'Rejected') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE,
    FOREIGN KEY (performed_by_id) REFERENCES Users(id) ON DELETE CASCADE
);

CREATE TABLE Accounts(
	id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    balance DECIMAL(15, 2) DEFAULT 1000,
    account_type ENUM('Savings', 'Checking') NOT NULL,
    status ENUM ('Active', 'Inactive', 'Closed') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE
);

CREATE TABLE Transactions(
	id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT NOT NULL,
    performed_by_id INT NOT NULL,
    transaction_type ENUM('Deposit', 'Withdraw', 'Transfer') NOT NULL,
    amount DECIMAL(15, 2) NOT NULL,
    status ENUM('Pending', 'Completed', 'Failed'),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY(account_id) REFERENCES Accounts(id) ON DELETE CASCADE,
    FOREIGN KEY(performed_by_id) REFERENCES Users(id) ON DELETE CASCADE
);


-- Registering customer or employee in the system
insert into Users (role, email, password)
values('Customer', 'ukcustomer@tcs.com', 'abc@1234');

 -- Account creating for the customer
insert into Accounts(user_id, balance, account_type, status)
values (last_insert_id(), 0.00, 'Savings', 'Active');

-- creating user profile for the same user
insert into UserProfiles (user_id, first_name, last_name, phone_no, address)
values (last_insert_id(), 'John', 'Doe', '1234' ,'123 Main street');

-- Fetching the User profile using users pk 
SELECT u.id AS user_id, u.emp_id, u.role, u.email, u.password, u.created_at, u.updated_at,
       up.first_name, up.last_name, up.phone_no, up.address
FROM Users u
JOIN UserProfiles up ON u.id = up.user_id
WHERE u.id = 1;




-- customer initiating the loan request 
insert into LoanRequests(user_id, loan_amount,loan_type, status)
values(last_insert_id(), 5000.00, 'Personal', 'Pending');



-- employee initiating the loan request 
insert into loanrequests (user_id, performed_by_id, loan_amount, loan_type, status)
values (
(select id from users where customer_ssn_id = 'c100'),
(select id from users where emp_id = 'e100'),
1000.00,
'Auto',
'Pending');

-- customer creating transaction
insert into Transactions (user_id, transaction_type, amount, status)
values (last_insert_id(), 'Deposit', '1000.00', 'Completed');

-- employee initiating the transaction for a customer
insert into transaction (account_id, performed_by_id, transaction_type, amount, status)
values (
	(select id from Accounts where user_id= (select id from Users where  customer_ssn_id="C100")),
    (select id from users where emp_id = 'E100'),
    'Deposit',
    2000.00,
    'Completed'
);


-- listing all transactions
select * from transactions;

-- listing all transaction created by particuclar emp
select t.*
from transactions t
join users u on t.performed_by_id = u.id
where u.emp_id = 'E100';
 


use bank;
show tables;

drop table Users;
drop table UserProfiles;
drop table Accounts;
drop table transactions;
drop table loanrequests;



