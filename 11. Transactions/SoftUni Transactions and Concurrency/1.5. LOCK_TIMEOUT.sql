/*============================================================================
	File:		1.5 - LOCK_TIMEOUT.sql

	Summary:	The script demonstrates the behaviour of the session-level
				option LOCK_TIMEOUT.

				THIS SCRIPT IS PART OF LECTURE: 
				SQL Server Transactions and Concurrency, SoftUni, Sofia

	Date:		February 2015

	SQL Server Version: 2005 / 2008 / 2012 / 2014
------------------------------------------------------------------------------
	Written by Boris Hristov, SQL Server MVP

	This script is intended only as a supplement to demos and lectures
	given by Boris Hristov.  
  
	THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF 
	ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED 
	TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
	PARTICULAR PURPOSE.
============================================================================*/

-- Create a database LockTimeout to play with
USE master
GO

-- Drop the database if it already exists
IF  EXISTS (
	SELECT name 
		FROM sys.databases 
		WHERE name = N'LockTimeout'
)
DROP DATABASE LockTimeout
GO

CREATE DATABASE LockTimeout
GO

-- =========================================
-- Create table DataTable to insert values in
-- =========================================
USE LockTimeout
GO

IF OBJECT_ID('DataTable', 'U') IS NOT NULL
  DROP TABLE DataTable
GO

CREATE TABLE DataTable (DataRow char(8000) NOT NULL)
GO


-- Let's insert some values

BEGIN TRANSACTION -- BEGIN TRAN is same 

INSERT INTO DataTable
VALUES ('SoftUni is in the house!')

--- now try to do anything (for example select) the record setting the LOCK_TIMEOUT to 2 seconds in another session

USE LockTimeout
GO

SET LOCK_TIMEOUT 2000 -- that's 2 seconds

SELECT * FROM dbo.DataTable

-- Query does not fail. It times out. 

-- LOCK_TIMEOUT is a session level option!!!

ROLLBACK

-- Truncate the first table

TRUNCATE TABLE DataTable

-- Create another table

USE LockTimeout
GO

IF OBJECT_ID('DataTable2', 'U') IS NOT NULL
  DROP TABLE DataTable
GO

CREATE TABLE DataTable2 (DataRow char(8000) NOT NULL)
GO

-- Insert records to the two tables in 2 different transactions comitting the first and leaving the second opened

BEGIN TRANSACTION 

INSERT INTO DataTable
VALUES ('SoftUni is in the house!')

COMMIT TRANSACTION

-- now in the new table

BEGIN TRAN -- BEGIN TRAN is same 

INSERT INTO DataTable2
VALUES ('SoftUni is in the house!')


--- now try to do anything (for example select) the record setting the LOCK_TIMEOUT to 2 seconds in another session

USE LockTimeout
GO

SET LOCK_TIMEOUT 2000 -- that's 2 seconds

SELECT * FROM dbo.DataTable
SELECT * FROM dbo.DataTable2

-- First query returns. Second times out.


