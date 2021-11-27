/*Exercise 1
Create a new database named Membership.*/

CREATE DATABASE Membership;
GO

/*Exerercise 2
Write the CREATE TABLE statements needed to implement the following
design in the Membership database. Include foreign key constraints. Define
IndividualID and GroupID as identity columns. Decide which columns should
allow null values, if any, and explain your decision. Define the Dues column
with a default of zero and a check constraint to allow only positive values.

ADDITIONAL REQUIREMENTS:
Individuals table name columns and phone number are REQUIRED, but address is not.  
Name columns should permit up to 30 characters, 
phone up to 20 characters, and 
address up to 100 charachters
The Dues column should have a default value of $1.00 and 
the "check constraint" should only permit values of $1.00 or more.
*/
/*
DROP TABLE Individuals --related table
DROP TABLE Groups
*/
--create Groups table first so that foreign key relationship can be set within Individuals table
CREATE TABLE Groups
(GroupID		INT				NOT NULL IDENTITY(100,100) PRIMARY KEY, --increment by 100
GroupName		VARCHAR(50)		NOT NULL);

GO

/*
Insert into Groups
(GroupName)
values
('Women');
Insert into Groups
(GroupName)
values
('Monster');

SELECT * FROM GROUPS
*/

CREATE TABLE Individuals
(IndvID			INT				NOT NULL IDENTITY(10,10) PRIMARY KEY, --increment by 10
GroupID			INT				NOT NULL REFERENCES Groups (GroupID), --FOREIGN KEY
IndvFName		VARCHAR(30)		NOT NULL,	 
IndvLName		VARCHAR(30)		NOT NULL, 
IndvAddr1		VARCHAR(100)		NULL, 
IndvAddr2		VARCHAR(100)		NULL, 
IndvCity		VARCHAR(30)			NULL, 
IndvState		VARCHAR(2)			NULL, 
IndvZip			VARCHAR(5)			NULL, 
IndvPhone		VARCHAR(20)		NOT NULL, 
IndvEmail		VARCHAR(50)			NULL, 
IndvDues		MONEY			NOT NULL	DEFAULT 1.00, 
CHECK (IndvDues >= 1));

GO

-- DROP TABLE Individuals
-- DELETE FROM Individuals --delete all records
-- SELECT * from Individuals
/*
Insert into Individuals
(GroupID, IndvFName, IndvLName, IndvPhone)
values
(100, 'Lilly', 'Munster', '3145551313');

Insert into Individuals
(GroupID, IndvFName, IndvLName, IndvPhone, IndvDues)
values
(200, 'Herman', 'Munster', '3145551313 x321', 150);

Insert into Individuals
(GroupID, IndvFName, IndvLName, IndvPhone, IndvEmail, IndvDues)
values
(100, 'Marilyn', 'Munster', '3145551313', 'hottie@muster.com', 75);

Insert into Individuals
(GroupID, IndvFName, IndvLName, IndvAddr1, IndvCity, IndvPhone, IndvEmail)
values
(200, 'Eddie', 'Munster', '1313 Mockingbird Lane', 'Unpleasantville', '3145550900', 'wolfie@munster.com');

Insert into Individuals
(GroupID, IndvFName, IndvLName, IndvAddr1, IndvCity, IndvState, IndvZip, IndvPhone, IndvEmail)
values
(200, 'Grandpa', 'Munster', '1313 Mockingbird Lane', 'Unpleasantville', 'MO', '63101', '3145550900', 'vampire@munster.com');

Insert into Individuals
(GroupID, IndvFName, IndvLName, IndvPhone, IndvDues)
values
--(1, 'Elvira', 'Darkness', '3145550900', 20); --no matching key in Groups
(100, 'Elvira', 'Darkness', '3145550900', 20);
*/


/*
*******************************************************
EXPLANATIONS FOR COLUMN DECISIONS
********************************************************
IndvID IDENTITY PRIMARY_KEY - key is generated
GroupID FOREIGN KEY to GROUPS 
FirstName varchar 30 NOT NULL --required less formal version of IndvID
LastName varchar 30 NOT NULL  --required less formal version of IndvID
Street Address1 varchar100 NULL --not required per specs
Street Address2 varchar100 NULL --not required per specs
City varchar 30 NULL --address not required so no need for this
State varchar 2 NULL --address not required so no need for this
Zip varchar 5 NULL --address not required so no need for this
Phone 20 NOT NULL --required to contact member since no address required
Email varchar 50 NULL --not everyone uses email GASP!
Dues money DEFAULT 1.00, check constraint for postive values >= $1.00 per specs
*/

/*Exerecise 3
Write the CREATE INDEX statements to create a clustered index on the
GroupID column and a nonclustered index on the IndividualID column of the
GroupMembership table.

ADDITIONAL REQUIREMENTS:
The first index should be called IDX_GroupID.  
The second index should be called IDX_IndividualID.  
NOTE: Naming the indexes something else will forfeit credit for this step.
*/

/*
CREATE TABLE GroupMembership
(GroupID	INT	NOT NULL REFERENCES Groups (GroupID),
IndvID		INT NOT NULL REFERENCES Individuals (IndvID));
GO
*/
CREATE CLUSTERED INDEX IDX_GroupID
	ON GroupMembership (GroupID);

CREATE INDEX IDX_IndividualID
	ON GroupMembership (IndvID);

/*Exercise 4
Write an ALTER TABLE statement that adds a new column, DuesPaid, to
the Individuals table. Use the bit data type, disallow null values, and assign a
default Boolean value of False.

ADDITIONAL REQUIREMENTS:
Follow the instructions from the text, except that the default value should be TRUE, 
not FALSE.  This is required to get full credit for this step.
*/
-- SELECT * FROM Individuals
ALTER TABLE Individuals
ADD DuesPaid BIT NOT NULL DEFAULT 1 -- 1 equates to TRUE

-- SELECT * FROM Individuals
/*
Insert into Individuals
(GroupID, IndvFName, IndvLName, IndvPhone, IndvDues, DuesPaid)
values
(200, 'Crypt', 'Keeper', '3145559977', 20, 0); --someone didn't pay!
-- SELECT * FROM Individuals
*/


/*Exercise 7
Write a SELECT statement that displays the collation name for the collation
that's used by the Membership database. If NULL is displayed for the collation
name, it means that there isn't an active connection to the Membership
database. To fix that, select the Membership database from the Available
Databases combo box in the SQL Editor toolbar.

ADDITIONAL REQUIREMENTS:
In addition to name and collation_name, select the create_date and 
two other columns of your choosing from the sys.databases table.
This is required to get full credit for this step.
*/
SELECT name, collation_name, create_date, is_memory_optimized_enabled, target_recovery_time_in_seconds
FROM sys.databases
WHERE name = 'Membership'
;