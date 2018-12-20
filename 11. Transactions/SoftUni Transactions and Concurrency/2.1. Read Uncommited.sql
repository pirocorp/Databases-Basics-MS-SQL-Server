/*============================================================================
	File:		2.1 - Read Uncommitted.sql

	Summary:	The script demonstrates how to simulate a dirty read and 
				how the read uncomitted isolation level acutally works.
				NOLOCK hint is also compared with the isolation level.

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


-- Create database IsolationLevels to play with
USE master
GO

-- Drop the database if it already exists
IF  EXISTS (
	SELECT name 
		FROM sys.databases 
		WHERE name = N'IsolationLevels'
)
DROP DATABASE IsolationLevels
GO

CREATE DATABASE IsolationLevels
GO

-- =========================================
-- Create table DataTable to insert values in
-- =========================================
USE IsolationLevels
GO

IF OBJECT_ID('DataTable', 'U') IS NOT NULL
  DROP TABLE DataTable
GO

CREATE TABLE DataTable (DataRow char(8000) NOT NULL)
GO


-- Let's insert some values

BEGIN TRANSACTION InsertValues 
WITH MARK N'READ UNCOMMITTED TRANSACTION'

INSERT INTO DataTable
VALUES ('Read Uncommited transaction')

--- now try to see if you can see the uncommitted record in separate session
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

USE IsolationLevels
GO

SELECT * FROM dbo.DataTable
--SELECT * FROM dbo.DataTable (NOLOCK)
--SELECT * FROM dbo.DataTable (READPAST)
--SELECT * FROM dbo.DataTable (READUNCOMMITTED)

--- Now rollback this record
ROLLBACK

--- Check again if you can see it?