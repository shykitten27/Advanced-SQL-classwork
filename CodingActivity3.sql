/*
Chpt 8 - Ex 1

Write a SELECT statement that returns four columns based on the InvoiceTotal column of the Invoices table:
•	Use the CAST function to return the first column as data type decimal with 2 digits to the right of the decimal point.
•	Use CAST to return the second column as a varchar.
•	Use the CONVERT function to return the third column as the same data type as the first column.
•	Use CONVERT to return the fourth column as a varchar, using style 1.
	
	Function syntax:
		CAST(expression AS data_type)
		CONVERT(data_ type, expression [, style])
		TRY_CONVERT(data_ type, expression[, style] )
*/
USE AP;
SELECT 
	CAST(InvoiceTotal AS numeric(17,2)) AS decTotal, --cast money to numeric is same as converting to decimal
	CAST(InvoiceTotal AS varchar) AS varcharTotal, --cast money as varchar ???
	TRY_CONVERT(varchar, InvoiceTotal, 0) AS varcharTotal_0, --0 is the default with 2 decimals
	TRY_CONVERT(varchar, InvoiceTotal, 1) AS varcharTotal_1  --1 specifies 2 decimals with commas
FROM Invoices;


/*
Write a SELECT statement that returns three columns based on the InvoiceDate column of the Invoices table:
• Use the CAST function to return the first column as data type varchar.
• Use the CONVERT function to return the second and third columns as (a varchar, using style 1 and style 10, respectively.
*/

USE AP; 
SELECT  
	CAST(InvoiceDate AS varchar) AS varcharDate,
	TRY_CONVERT(varchar, InvoiceDate, 1) AS varcharDate_1,	-- date with slashes
	TRY_CONVERT(varchar, InvoiceDate, 10) AS varcharDate_10 --date with dashes
FROM Invoices; 
