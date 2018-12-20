/*============================================================================
	File:		2.2 - Repeatable Read.sql

	Summary:	The script demonstrates how to simulate and what is the 
				behaviour of Repeatable Read isolation level and what problems
				it cannot solve.

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

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
GO

BEGIN TRANSACTION READSOMEROWS

USE AdventureWorks2012
GO

SELECT * FROM HumanResources.JobCandidate
WHERE JobCandidateID > 1

commit 

rollback

--- run this in a second query window 
BEGIN TRANSACTION 

UPDATE HumanResources.JobCandidate
SET BusinessEntityID = 67
WHERE JobCandidateID = 12

--- Can we insert though?

BEGIN TRAN

INSERT INTO [HumanResources].[JobCandidate]
           ([BusinessEntityID]
           ,[Resume]
           ,[ModifiedDate])
     VALUES
           (200, NULL,'2001-07-24 00:00:00.000')
GO

ROLLBACK


