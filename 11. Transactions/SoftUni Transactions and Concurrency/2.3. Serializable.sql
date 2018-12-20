/*============================================================================
	File:		2.3 - Serializable.sql

	Summary:	The script demonstrates how to simulate and what is the 
				behaviour of Serializable isolation level and how it solves
				the Phantom Record problem. It also demonstrates how the 
				information about the session's isolation level can be found.

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


SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO

Use AdventureWorks2012
GO

BEGIN TRANSACTION READSOMEROWS

SELECT FirstName FROM Person.PersonCopied
WHERE FirstName LIKE 'B%'

Commit

--- run this in a second query window 

USE [AdventureWorks2012]
GO

INSERT INTO [Person].[PersonCopied]
           ([BusinessEntityID]
           ,[PersonType]
           ,[NameStyle]
           ,[Title]
           ,[FirstName]
           ,[MiddleName]
           ,[LastName]
           ,[Suffix]
           ,[EmailPromotion]
           ,[AdditionalContactInfo]
           ,[Demographics]
           ,[rowguid]
           ,[ModifiedDate])
     VALUES
           (9999,'EM',0,'Mr.','Boris','Raichev','Hristov','Mr.',1, NULL, NULL,'92C4119F-1207-48A3-8448-4636514EB7E2','2002-02-24 00:00:00.000')

--- let's see what was locked and by whom

sp_whoisactive @get_plans=1, @get_additional_info=1
		   

rollback

