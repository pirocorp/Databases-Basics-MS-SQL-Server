/*============================================================================
	File:		1.3 - Deadlock Session 2.sql

	Summary:	The script demonstrates how to create the second session
				needed for the deadlock to happen. This session is set 
				with HIGH DEADLOCK_PRIORITY, so it will be the one that 
				will "survive".

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


SET DEADLOCK_PRIORITY HIGH


-- updata AddressID 1 

BEGIN TRANSACTION

USE AdventureWorks2012
GO

update [Person].[Address]
set AddressLine1='ResourceB' where AddressID=1

-- After updating Address ID 1, session two wants to update Address ID 2 also
-- However, this record is already locked by session one, so we will wait

update [Person].[Address]
set AddressLine1='ResourceA_Updated' where AddressID=2

-- now back to session 1 to cause the deadlock

--ROLLBACK
