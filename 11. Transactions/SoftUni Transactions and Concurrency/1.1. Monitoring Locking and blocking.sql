/*============================================================================
	File:		1.1 - Monitoring Locking and Blocking.sql

	Summary:	The script demonstrates how to create a simple blocking
				scenario and how to see who blocks who and what locks
				each one of the session is actually holding.

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

-- SHOW BLOCKED PROCESSES REPORT 
-- ENABLE EXTENDED EVENT SESSION


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

--- create a simple table
USE IsolationLevels
GO

IF OBJECT_ID('DataTable', 'U') IS NOT NULL
  DROP TABLE DataTable
GO

CREATE TABLE DataTable (DataRow char(8000) NOT NULL)
GO


BEGIN TRANSACTION InsertValues 

INSERT INTO DataTable
VALUES ('Read committed transaction')

--- now try to see this in separate session
USE IsolationLevels
GO

BEGIN TRANSACTION

SELECT * FROM dbo.DataTable

--- in third session
--- let's see the locks that we have taken

SELECT  request_session_id ,
        DB_NAME(resource_database_id) AS [Database] ,
        resource_type ,
        resource_subtype ,
        request_type ,
        request_mode ,
        resource_description ,
        request_mode ,
        request_owner_type
FROM    sys.dm_tran_locks
WHERE   request_session_id > 50
        AND resource_database_id = DB_ID()
        AND request_session_id <> @@SPID
ORDER BY request_session_id ;


--- why not trying to understand by using this procedure
--- written by Adam Mechanic
--- Download: http://sqlblog.com/blogs/adam_machanic/archive/2012/03/22/released-who-is-active-v11-11.aspx

sp_whoisactive

ROLLBACK
