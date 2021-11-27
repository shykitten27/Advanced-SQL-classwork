/*1. Write a SELECT statement that returns two columns based on the Vendors
table. The first column, Contact, is the vendor contact name in this format:
first name followed by last initial (for example, "John S.") The second
column, Phone, is the VendorPhone column WITHOUT the area code. Only
return rows for those vendors in the 559 area code. Sort the result set by first
name, then last name.
*/

USE AP;
SELECT 
VendorContactFName + ' ' + LEFT(VendorContactLName, 1) + '.' AS Contact, 
RIGHT(VendorPhone, 8) AS Phone 
FROM Vendors
WHERE SUBSTRING(VendorPhone, 2, 3) = '559' --34 rows returned
ORDER BY VendorContactFName, VendorContactLName; --sort by original column names

/*
2. Write a SELECT statement that returns the InvoiceNumber and balance due
for every invoice with a non-zero balance AND an InvoiceDueDate that's less
than 30 days from today.
*/
USE AP;
SELECT InvoiceNumber, /*InvoiceDueDate,*/ --confirm dates less than 30 days
	   InvoiceTotal - PaymentTotal - CreditTotal AS BalanceDue
FROM Invoices
WHERE 
	InvoiceDueDate < GETDATE() + 30   --less than 30 days from TODAY
	AND
	InvoiceTotal - PaymentTotal - CreditTotal > 0 -- non-zero BalanceDue
--resultset 11 rows since the data is from 2020 AND only 11 have a BalanceDue

/*select InvoiceDate, DATEDIFF(day, InvoiceDueDate, GETDATE()) AS Diff
from Invoices
Select DATEDIFF(day, '2021-01-22', GETDATE())
from Invoices
*/

/*
3. Modify the search expression for InvoiceDueDate from the solution for
exercise 2. Rather than 30 days from today, return invoices due before the last
day of the current month.
*/
USE AP;
SELECT InvoiceNumber, /*InvoiceDueDate,*/
	   InvoiceTotal - PaymentTotal - CreditTotal AS BalanceDue
FROM Invoices
WHERE 
	InvoiceDueDate < EOMonth(GETDATE())  --less than CURRENT EOM date
	AND
	InvoiceTotal - PaymentTotal - CreditTotal <> 0 -- non-zero BalanceDue
--resultset 11 rows since the data is from 2020 and prior AND only 11 have a BalanceDue

/*4. Write a summary query that uses the CUBE operator to return LineltemSum
(which is the sum of InvoiceLineltemAmount) grouped by Account (an alias
for AccountDescription) and State (an alias for VendorState). Use the CASE
and GROUPING function to substitute the literal value "*ALL*" for the
summary rows with null values.
*/
--pull values from 4 tables
USE AP
SELECT 
--i.VendorID, li.AccountNo, 
CASE --this represents a column in select named State based off v.VendorState
	WHEN GROUPING(v.VendorState) = 1 --1 IS NULL
		THEN '*ALL*' --substituing string literal instead of NULL in CASE/IF 
	ELSE
		v.VendorState
END AS State, --comma to continue column selection
CASE --this represents a column in select named Account based off gl.AccountDescription
	WHEN GROUPING(gl.AccountDescription) = 1 --1 IS NULL
		THEN '*ALL*' --substituing string literal instead of NULL in CASE/IF
	ELSE
		gl.AccountDescription
END AS Account, --comma to continue column selection

SUM(li.InvoiceLineItemAmount) AS LineltemSum --this is the summation column 
										     --of ROWS of LineItemAmounts
--the following are the fourn tables joined to pull necessary column data
FROM InvoiceLineItems li       --1st table
JOIN Invoices i                --2nd table
ON li.InvoiceID = i.InvoiceID  --specify relationship
JOIN Vendors v                 --3rd table
ON v.VendorID = i.VendorID     --specify relationship
JOIN GLAccounts gl             --4th table
ON gl.AccountNo = li.AccountNo --specify relationship
--the following is the rollup CUBEing GROUPED by the actual column names
GROUP BY CUBE(gl.AccountDescription, v.VendorState) --column names not alias
--resultset 65 rows with rollups by Accounts within State and then by ALL Accounts


/*
5. Add a column to the query described in exercise 2 that uses the RANK()
function to return a column named BalanceRank that ranks the balance due in
descending order.
*/
USE AP;
--SELECT RANK() OVER (ORDER BY InvoiceTotal - PaymentTotal - CreditTotal DESC) As BalanceRank,
SELECT InvoiceNumber, /*InvoiceDueDate,*/ --confirm dates less than 30 days
	   InvoiceTotal - PaymentTotal - CreditTotal AS BalanceDue,
	   RANK() OVER (ORDER BY InvoiceTotal - PaymentTotal - CreditTotal DESC) As BalanceRank
FROM Invoices
WHERE 
	InvoiceDueDate < GETDATE() + 30   --less than 30 days from TODAY
	AND
	InvoiceTotal - PaymentTotal - CreditTotal > 0 -- non-zero BalanceDue

--resultset same 11 rows with rank