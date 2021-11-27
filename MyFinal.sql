/*	Creates a result set of invoiceIDs with more than one line item
	blah blah blah...
	more details here...
	Author:			Donna Seidel
	Created:		2021-05-11
	Return value:	Result set includes the VendorID, InvoiceNumber, 
					InvoiceDate, InvoiceTotal, InvoiceLineItem, InvoiceLineItemDescription,
					AccountNo, VendorName and AccountDescription for each invoice that has
					more than one line item. 

					Throw an error if no invoices found with more than one line item
*/

USE AP;
GO

IF OBJECT_ID('spMultiLineItemInvoices') IS NOT NULL
	DROP PROC spMultiLineItemInvoices;
GO

CREATE PROC dbo.spMultiLineItemInvoices
 
AS

DECLARE @invoice_count INT;
--setup a record processing counter


--Find all invoiceIDs with more than one line item
	select distinct InvoiceID into #multipleLines from Invoices
	--select * from InvoiceLineItems where InvoiceSequence > 1
	SELECT @invoice_count=@@ROWCOUNT; --pass as an output parameter or sent as return???



--Get columns we want from Invoices for this list
select i.VendorID, i.InvoiceNumber, i.InvoiceDate, i.InvoiceTotal, 
l.InvoiceLineItemAmount, l.InvoiceLineItemDescription, l.AccountNo
into #details
from Invoices i 
join #multipleLines m on i.InvoiceID = m.InvoiceID
join InvoiceLineItems l on i.InvoiceID = l.InvoiceID


--Find Vendor and Account information
select d.*, v.VendorName, g.AccountDescription
into #details2
from #details d
join Vendors v on d.VendorID = v.VendorID
join GLAccounts g on d.AccountNo = g.AccountNo

--Data to display in Excel or TXT file:
select * from #details2 order by AccountNo, InvoiceLineItemAmount
GO

EXEC spMultiLineItemInvoices; 