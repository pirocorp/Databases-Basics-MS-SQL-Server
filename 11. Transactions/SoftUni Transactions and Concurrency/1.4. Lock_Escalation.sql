/*============================================================================
	File:		1.4 - Lock Escalation.sql

	Summary:	The script demonstrates how to simulate Lock Escalation on 
				both table and partition level

				THIS SCRIPT IS PART OF LECTURE: 
				SQL Server Transactions and Concurrency, SoftUni, Sofia

	Date:		February 2015

	SQL Server Version: 2008 / 2012 / 2014
------------------------------------------------------------------------------
	Written by Paul Randal
	Modified by Boris Hristov, SQL Server MVP

	This script is intended only as a supplement to demos and lectures
	given by Boris Hristov.  
  
	THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF 
	ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED 
	TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
	PARTICULAR PURPOSE.
============================================================================*/

USE master
GO

-- Drop the database if it already exists
IF  EXISTS (
	SELECT name 
		FROM sys.databases 
		WHERE name = N'LockEscalationTest'
)
DROP DATABASE LockEscalationTest
GO

-- Create an empty database to play with

CREATE DATABASE LockEscalationTest;
GO 

USE LockEscalationTest;
GO 	

-- Create three partitions: up to 7999, 8000-15999, 16000+
CREATE PARTITION FUNCTION MyPartitionFunction (INT) AS RANGE RIGHT FOR VALUES (8000, 16000);
GO 

CREATE PARTITION SCHEME MyPartitionScheme AS PARTITION MyPartitionFunction
ALL TO ([PRIMARY]);
GO 

-- Create a partitioned table
CREATE TABLE MyPartitionedTable (c1 INT);
GO 

CREATE CLUSTERED INDEX MPT_Clust ON MyPartitionedTable (c1)
ON MyPartitionScheme (c1);
GO 



-- Fill the table
SET NOCOUNT ON;
GO 

DECLARE @a INT = 1;
WHILE (@a < 17000)
BEGIN
INSERT INTO MyPartitionedTable VALUES (@a);
SELECT @a = @a + 1;
END;
GO


-- Set lock escalation level to TABLE 
ALTER TABLE MyPartitionedTable SET (LOCK_ESCALATION = TABLE);
GO 

-- now update some values in partition 1 (more than 5000)
-- and do not commit the transaction

BEGIN TRAN
 UPDATE MyPartitionedTable SET c1 = c1 WHERE c1 < 7500;
GO 

-- check what locks are we holding (yes, we hold exclusive TABLE lock already!)

SELECT 
	[resource_type], 
	[resource_associated_entity_id], 
	[request_mode],
	[request_type], 
	[request_status] 
FROM sys.dm_tran_locks 
WHERE [resource_type] <> 'DATABASE';
GO 

-- in a new session
-- lets try to select some data from the partitions

SELECT c1 FROM MyPartitionedTable
WHERE c1 < 15900 


ROLLBACK TRAN;
GO 

ALTER TABLE MyPartitionedTable SET (LOCK_ESCALATION = AUTO);
GO 

BEGIN TRAN
 UPDATE MyPartitionedTable SET c1 = c1 WHERE c1 < 7500;
GO 

--- what are our partition IDs and which is locked now?
SELECT [partition_id], [object_id], [index_id], [partition_number]
FROM sys.partitions WHERE object_id = OBJECT_ID ('MyPartitionedTable');
GO 

SELECT 
	[resource_type], 
	[resource_associated_entity_id], 
	[request_mode],
	[request_type], 
	[request_status] 
FROM sys.dm_tran_locks 
WHERE [resource_type] <> 'DATABASE';
GO



-- now let's try to update data in the second partition
USE LockEscalationTest;
GO 

BEGIN TRAN
UPDATE MyPartitionedTable set c1 = c1 WHERE c1 > 8100 AND c1 < 15900;
GO 

SELECT [partition_id], [object_id], [index_id], [partition_number]
FROM sys.partitions WHERE object_id = OBJECT_ID ('MyPartitionedTable');
GO 

SELECT 
	[resource_type], 
	[resource_associated_entity_id], 
	[request_mode],
	[request_type], 
	[request_status] 
FROM sys.dm_tran_locks 
WHERE [resource_type] <> 'DATABASE';
GO


-- in a new session
-- now lets try to select some data from the partitions

SELECT c1 FROM MyPartitionedTable
WHERE c1 > 16000 

ROLLBACK