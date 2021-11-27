/*3. Create a stored procedure named spDateRange that accepts two parameters,
@minDate and @maxDate both VARCHAR(30) and default value null.
If called with no parameters or with null values, raise an error that describes
the problem - use 60001, 60002, and 60003 as your error numbers.
If called with non-null values, validate the parameters. Test
that the literal strings are valid dates and test that @minDate is earlier than
@maxDate. If the parameters are valid, return a result set that includes the
InvoiceNumber, InvoiceDate, InvoiceDueDate, InvoiceTotal, and Balance for each invoice for
which the InvoiceDate is within the date range, sorted with earliest invoice
first. 10/01 - 10/31

Exercise 3, but with the following modifications from the text:
i. the variables should be called @minDate and @maxDate and be VARCHAR(30)
ii. use 60001, 60002, and 60003 as your error numbers.
iii. include InvoiceDueDate in your returned recordset (when parameters are valid)
*/

/*	Creates a result set of invoices within range of two parameter dates
	blah blah blah...
	more details here...
	Author:			Donna Seidel
	Created:		2021-3-09
	Return value:	Result set includes the InvoiceNumber, InvoiceDate, 
					InvoiceDueDate, InvoiceTotal, and Balance for each invoice 
					for which the InvoiceDate is within the date range, 
					sorted with earliest invoice first.
					0 if unsuccessful
*/

USE AP;
GO

IF OBJECT_ID('spDateRange') IS NOT NULL
	DROP PROC spDateRange;
GO

CREATE PROC dbo.spDateRange
	@minDate		varchar(30) = NULL,
	@maxDate		varchar(30) = NULL
 
AS

IF @minDate IS NULL OR @maxDate IS NULL
THROW 60001, 'Missing parameter(s).', 1;

IF ISDATE(@minDate) = 0 OR ISDATE(@maxDate) = 0
THROW 60002, 'Invalid date(s).', 1;

--test that @minDate is earlier than @maxDate else THROW error 60003
IF DATEDIFF(day, @minDate, @maxDate) < 0 --meaning negative range of days
THROW 60003, '@minDate must be earlier than @maxDate.', 1;

DECLARE @invoice_count INT;
--setup a record processing counter

--if no results for date range, send back messsage 'No results for date range.' 
BEGIN
	SELECT --select the column values into the parm @variables
		InvoiceNumber,
		InvoiceDate,
		InvoiceDueDate,
		InvoiceTotal,
		InvoiceBalance=(InvoiceTotal - CreditTotal - PaymentTotal)
	FROM
		Invoices
	WHERE
		InvoiceDate >= @minDate
		AND InvoiceDate <= @maxDate
	ORDER BY
		InvoiceDate;
	SELECT @invoice_count=@@ROWCOUNT; --pass as an output parameter or sent as return???
END

GO
--end of spDateRange

--script that calls EXEC spDateRange passing the parms

BEGIN TRY
--	DECLARE @variables use to receive columns of resultset 
	DECLARE @count INT;

	EXEC spDateRange  --passing all of the parameters 
		@minDate='2019-10-01', 
		@maxDate='2019-10-31';
		--@invoice_count = @count OUTPUT;

END TRY
BEGIN CATCH
	PRINT 'An error occurred.';
	PRINT 'Message: ' + CONVERT(varchar, ERROR_MESSAGE ( )) ;
	IF ERROR_NUMBER ( ) >= 60000
		PRINT 'This is a custom error message.';
END CATCH; 

--change parms to test for all error messages
/*
4. Code a call to the stored procedure created in exercise 3 that returns invoices
with an InvoiceDate between 10/1/2019 and 10/31/2019. This call
should also catch any errors that are raised by the procedure and print the
error number and description.
Exercise 4, but with the following modifications from the text:
i. the date range should be 10/1/2019 and 10/31/2019
*/
BEGIN TRY
--	DECLARE @variables use to receive columns of resultset 

	EXEC spDateRange  --passing all of the parameters 
		@minDate='2019-10-01', 
		@maxDate='2019-10-31';
		--@invoice_count = @count OUTPUT;

END TRY
BEGIN CATCH
	PRINT 'An error occurred.';
	PRINT 'Message: ' + CONVERT(varchar, ERROR_MESSAGE ( )) ;
	IF ERROR_NUMBER ( ) >= 60000
		PRINT 'This is a custom error message.';
END CATCH; 

/*
6. Create a table-valued function named fnValidDateRange, similar to the stored
procedure of exercise 3. The function requires two parameters of data type
date. Don't validate the parameters. Return a result set that includes the
InvoiceNumber, InvoiceDate, InvoiceDueDate, InvoiceTotal, and Balance for each invoice
for which the InvoiceDate is within the date range. Invoke the function
from within a SELECT statement to return those invoices with InvoiceDate
between 10/1/2019 and 10/30/2019.

Exercise 6, but with the following modifications from the text:
i. call your function fnValidDateRange
ii. call your parameters @minDate and @maxDate
iii. include InvoiceDueDate with your records along with the other columns the text asks for
iv. use 10/1/2019 and 10/30/2019 instead of the dates specified in the text
*/
USE AP;
GO ---CREATE in own batch

CREATE FUNCTION fnValidDateRange
	(@minDate date, @maxDate date)
	RETURNS table
RETURN
	(SELECT 
		InvoiceNumber,
		InvoiceDate,
		InvoiceDueDate,
		InvoiceTotal,
		InvoiceBalance=InvoiceTotal - CreditTotal - PaymentTotal
	FROM
		Invoices
	WHERE
		InvoiceDate >= @minDate
		AND InvoiceDate <= @maxDate);
GO ---CREATE in own batch and to ensure creation before invoking

SELECT * FROM dbo.fnValidDateRange('2019-10-01', '2019-10-31');

/*
7. Use the function fnValidDateRange you created in exercise 6 in a SELECT statement that returns
five columns: VendorName and the four columns returned by the function. 
Use the following aliases in your query: "v" for Vendors, "i" for Invoices

Exercise 7, but with the following modifications from the text:
i. Use the following aliases in your query: "v" for Vendors, "i" for Invoices
ii. Make sure you use the function name specified in Exercise 6
*/

/* 
SELECT v.VendorName, i.InvoiceNumber ---114 rows of 2 columns, one could be used to link to function column
FROM Vendors v
JOIN Invoices i 
ON v.VendorID = i.VendorID
ORDER BY InvoiceNumber

SELECT * FROM dbo.fnValidDateRange('2019-10-01', '2019-10-31'); --13 rows of 5 columns
*/

--join the 114 rows to 13 rows on InvoiceNumber using the function derived table correlated with AS
SELECT v.VendorName, Range.InvoiceNumber, Range.InvoiceDueDate, Range.InvoiceTotal, Range.InvoiceTotal
FROM Vendors v
JOIN Invoices i 
ON v.VendorID = i.VendorID
JOIN dbo.fnValidDateRange('2019-10-01', '2019-10-31') AS Range 
ON i.InvoiceNumber = Range.InvoiceNumber