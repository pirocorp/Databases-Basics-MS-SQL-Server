/*============================================================================
	File:		2.4 - Serializable.sql

	Summary:	The script demonstrates how to check, enable and work with
				RCSI - Read Committed Snapshot Isolation Level. It also shows
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

SELECT name, --snapshot_isolation_state_desc,
is_read_committed_snapshot_on
FROM sys.databases
WHERE name= 'AdventureWorks2012';
GO


-- check the version store - sholud be empty 

use tempdb
go
SELECT SUM(version_store_reserved_page_count) AS [version store pages used],
	   (SUM(version_store_reserved_page_count)*1.0/128) AS [version store space in MB]
FROM sys.dm_db_file_space_usage;

--- enable read_commited_snapshot isolation 

USE [master]
GO
ALTER DATABASE [AdventureWorks2012] SET 
READ_COMMITTED_SNAPSHOT ON WITH NO_WAIT
GO

--- Session 1: Select some data
BEGIN TRAN 

USE AdventureWorks2012
GO
SELECT * FROM Person.Person -- check for BORIS%


--- update the record in the second session and then select again (without committing!)

BEGIN TRAN

USE AdventureWorks2012
GO

UPDATE Person.Person
SET FirstName = 'Boris223' --- check the record 
WHERE FirstName = 'Boris2133'

COMMIT 

--- check the version store

use tempdb
go
SELECT SUM(version_store_reserved_page_count) AS [version store pages used],
	   (SUM(version_store_reserved_page_count)*1.0/128) AS [version store space in MB]
FROM sys.dm_db_file_space_usage;

--- commit the update

--- select again
USE AdventureWorks2012
GO

SELECT * FROM Person.Person -- check for BORIS%

--- check the version store

use tempdb
go
SELECT SUM(version_store_reserved_page_count) AS [version store pages used],
	   (SUM(version_store_reserved_page_count)*1.0/128) AS [version store space in MB]
FROM sys.dm_db_file_space_usage;

--- Commit and wait for the version to not be used

COMMIT
--- Rollback
USE [master]
GO
ALTER DATABASE [AdventureWorks2012] SET READ_COMMITTED_SNAPSHOT OFF WITH NO_WAIT
GO

ROLLBACK