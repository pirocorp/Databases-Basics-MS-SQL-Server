/*============================================================================
	File:		1.2 - Deadlock Session 1.sql

	Summary:	The script demonstrates how to create the first from the two
				sessions that will cause a deadlock scenario. This will be 
				the session that will be chosen for deadlock victim.

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

-- SHOUT OUT TO SQL SERVER: "KILL ME, KILL ME!"
SET DEADLOCK_PRIORITY LOW  

--- first let's update AddressID 2
USE AdventureWorks2012
GO
BEGIN TRANSACTION
 
UPDATE [Person].[Address]
SET AddressLine1='Resource1' 
WHERE AddressID=2

--- now in session two let's update AddressID 1


--- now session one tries to update the already locked row by session 2 and causes deadlock

update [Person].[Address]
set AddressLine1='Resource2_Updated' where AddressID=1

ROLLBACK