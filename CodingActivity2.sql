/*
Exercise 1
SELECT DISTINCT VendorName FROM Vendors 
JOIN Invoices ON 
Vendors.VendoriD = Invoices . VendoriD
ORDER BY VendorName;
*/


SELECT DISTINCT VendorName FROM Vendors v
WHERE VendorID IN
	(SELECT VendorID 
	FROM Invoices i
	WHERE i.VendorID = v.VendorID)
ORDER BY VendorName

/*
Exercise 2
Write a SELECT statement that answers this question: Which invoices have
a PaymentTotal that's greater than the average PaymentTotal for all paid
invoices? Return the InvoiceNumber and InvoiceTotal for each invoice.
*/

SELECT InvoiceNumber, InvoiceTotal 
FROM Invoices
WHERE PaymentTotal >
	(SELECT AVG(InvoiceTotal) FROM Invoices)
--ORDER BY InvoiceTotal

/*
Exercise 4
Write a SELECT statement that returns two columns from the GLAccounts
table: AccountNo and AccountDescription. The result set should have one
row for each account number that has never been used. Use a correlated
subquery introduced with the NOT EXISTS operator. Sort the final result set
by AccountNo.
*/

/*SELECT AccountNo, AccountDescription 
	FROM GLAccounts 
ORDER BY AccountNo
--75 total accounts

SELECT DISTINCT AccountNo
	FROM InvoiceLineItems 
ORDER BY AccountNo
--21 accounts used for invoicing

*/

SELECT AccountNo, AccountDescription 
FROM GLAccounts g
WHERE NOT EXISTS
	(SELECT AccountNo
	FROM InvoiceLineItems l
	WHERE l.AccountNo = g.AccountNo)
ORDER BY AccountNo
--54 accounts that are NOT used for invoicing


/*
Exercise 5 -- START HERE
Write a SELECT statement that returns four columns: VendorName,
InvoiceiD, InvoiceSequence, and InvoiceLineltemAmount for each invoice
that has more than one line item in the InvoiceLineitems table.
Hint: Use a subquery that tests for InvoiceSequence > 1.
*/

/*
SELECT DISTINCT InvoiceID 
from InvoiceLineItems 
where InvoiceSequence > 1 
*/--only two invoices

SELECT DISTINCT VendorName, i.InvoiceID, InvoiceSequence, InvoiceLineItemAmount
from Vendors, Invoices i, InvoiceLineItems AS Inv_Main
WHERE i.InvoiceID = Inv_Sub.InvoiceID

	(SELECT InvoiceID
	FROM InvoiceLineItems AS Inv_Sub
	WHERE InvoiceSequence > 1) 
	
	-- 12 & 78 only InvoidIDs with multiple InvoiceSequence


--text example
/*SELECT AVG(InvoiceTotal)
	FROM Invoices 
	WHERE VendoriD = 34 */ --verify

SELECT VendorID, InvoiceNumber, InvoiceTotal
FROM Invoices AS Inv_Main
WHERE InvoiceTotal >
	(SELECT AVG(InvoiceTotal)
	FROM Invoices AS Inv_Sub
	WHERE Inv_Sub.VendoriD = Inv_Main.VendorID)
ORDER BY VendoriD, InvoiceTotal





/*
Exercise 7
Write a SELECT statement that returns the name, city, and state of each
vendor that's located in a unique city and state. In other words, don't include
vendors that have a city and state in common with another vendor.
*/