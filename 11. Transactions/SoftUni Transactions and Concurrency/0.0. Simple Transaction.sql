/*============================================================================
	File:		0.0 - Simple Transaction.sql

	Summary:	The script demonstrates the behaviour of a stored procedure
				which is being executed with and without being part of a 
				transaction.

				THIS SCRIPT IS PART OF LECTURE: 
				SQL Server Transactions and Concurrency, SoftUni, Sofia

	Date:		February 2015

	SQL Server Version: 2008 / 2012 / 2014
------------------------------------------------------------------------------
	Written by Boris Hristov, SQL Server MVP

	This script is intended only as a supplement to demos and lectures
	given by Boris Hristov.  
  
	THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF 
	ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED 
	TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
	PARTICULAR PURPOSE.
============================================================================*/

USE tempdb
GO
-- Create 3 Test Tables
CREATE TABLE TABLE1 (ID INT);
CREATE TABLE TABLE2 (ID INT);
CREATE TABLE TABLE3 (ID INT);
GO

-- Create SP
CREATE PROCEDURE TestSP
AS
	INSERT INTO TABLE1 (ID)
	VALUES (1)
	INSERT INTO TABLE2 (ID)
	VALUES ('a')
	INSERT INTO TABLE3 (ID)
	VALUES (3)
GO

-- Execute SP
-- SP will error out
EXEC TestSP
GO

-- Check the Values in Table
SELECT * FROM TABLE1;
SELECT * FROM TABLE2;
SELECT * FROM TABLE3;
GO


--- Truncate the tables
TRUNCATE TABLE Table1
TRUNCATE TABLE Table2
TRUNCATE TABLE Table3

-- Create a stored procedure wrapping the inserts in a transaction
CREATE PROCEDURE TestSPTran
AS
BEGIN TRAN
	INSERT INTO TABLE1 (ID)
	VALUES (11)
	INSERT INTO TABLE2 (ID)
	VALUES ('b')
	INSERT INTO TABLE3 (ID)
	VALUES (33)
COMMIT
GO

-- Execute SP
EXEC TestSPTran
GO

-- Check the Values in Table
SELECT * FROM TABLE1;
SELECT * FROM TABLE2;
SELECT * FROM TABLE3;
GO

-- Rollback:

DROP TABLE Table1
DROP TABLE Table2
DROP TABLE Table3
GO