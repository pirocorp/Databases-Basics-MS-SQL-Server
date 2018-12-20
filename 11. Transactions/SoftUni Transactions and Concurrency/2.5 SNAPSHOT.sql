/*============================================================================
	File:		2.4 - SNAPSHOT.sql

	Summary:	The script demonstrates how to check, enable and work with
				SI - Snapshot Isolation Level. It also shows
				how to find how much space is taken by version in the tempdb's
				version store area.

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

--- check if the database is enabled for RCSI

SELECT name, snapshot_isolation_state_desc
FROM sys.databases
WHERE name= 'AdventureWorks2012';
GO

-- check the version store - sholud be empty

use tempdb
go
SELECT SUM(version_store_reserved_page_count) AS [version store pages used],
	   (SUM(version_store_reserved_page_count)*1.0/128) AS [version store space in MB]
FROM sys.dm_db_file_space_usage;



--- enable snapshot isolation level 

USE [master]
GO
ALTER DATABASE [AdventureWorks2012] SET ALLOW_SNAPSHOT_ISOLATION ON
GO


--- Session 1: Select some data

SET TRANSACTION ISOLATION LEVEL SNAPSHOT

BEGIN TRAN 

USE AdventureWorks2012
GO
SELECT COUNT(*) FROM Person.PersonCopied -- records: 

--- delete some records second session
--- check the version store and then select again


--- Session 2: Delete some data
BEGIN TRAN 

USE AdventureWorks2012

DELETE TOP (50) FROM Person.PersonCopied

COMMIT


SELECT COUNT(*) FROM Person.PersonCopied -- records: 

--- commit the transaction and select again

COMMIT

SELECT COUNT(*) FROM Person.PersonCopied -- records: 




--- Disable SI

USE [master]
GO
ALTER DATABASE [AdventureWorks2012] SET ALLOW_SNAPSHOT_ISOLATION OFF
GO
