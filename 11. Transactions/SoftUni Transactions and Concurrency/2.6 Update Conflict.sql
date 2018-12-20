/*============================================================================
	File:		3.1 - Update Conflict.sql

	Summary:	The script demonstrates how to to simulate an update conflict
				in Snapshot Isolation Level scenario. 

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

-- Set the database to SNAPSHOT ISOLATION

ALTER DATABASE AdventureWorks2012
SET ALLOW_SNAPSHOT_ISOLATION ON


--start session 1 tran
--session 1
USE AdventureWorks2012
GO
SET TRANSACTION ISOLATION LEVEL SNAPSHOT
BEGIN TRAN

SELECT Quantity
FROM Production.ProductInventory
WHERE ProductID = 872;

--begin session 2 tran without committing

BEGIN TRAN 

UPDATE Production.ProductInventory
SET Quantity=Quantity + 300
WHERE ProductID = 872;

-- COMMIT


--session 1
USE AdventureWorks2012
GO

UPDATE Production.ProductInventory
SET Quantity=Quantity + 200
WHERE ProductID = 872;

--blocks
--now go and commit session's 2 update


--rollback
use master 
go

ALTER DATABASE AdventureWorks2012
SET READ_COMMITTED_SNAPSHOT OFF;

ALTER DATABASE AdventureWorks2012
SET ALLOW_SNAPSHOT_ISOLATION OFF

