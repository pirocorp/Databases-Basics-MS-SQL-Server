/*============================================================================
	File:		0.1 - Statements and errors.sql

	Summary:	The script demonstrates the behaviour of transactions when
				there are compile time or runtime erros in the execution of the
				code. 

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

USE AdventureWorks2012;
GO
IF OBJECT_ID(N'TestBatch', N'U') IS NOT NULL
    DROP TABLE TestBatch;
GO
---compile errors - nothing executed
CREATE TABLE TestBatch (Cola INT PRIMARY KEY, Colb CHAR(3));
GO
INSERT INTO TestBatch VALUES (1, 'aaa');
INSERT INTO TestBatch VALUES (2, 'bbb');
INSERT INTO TestBatch VALUSE (3, 'ccc');  -- Compile error error.
GO
SELECT * FROM TestBatch;  -- Returns no rows.
GO


---run time error - partially executed 

USE AdventureWorks2012;
GO
IF OBJECT_ID(N'TestBatch', N'U') IS NOT NULL
    DROP TABLE TestBatch;
GO
CREATE TABLE TestBatch (Cola INT PRIMARY KEY, Colb CHAR(3));
GO
INSERT INTO TestBatch VALUES (1, 'aaa');
INSERT INTO TestBatch VALUES (2, 'bbb');
INSERT INTO TestBatch VALUES (1, 'ccc');  -- Duplicate key error.
GO
SELECT * FROM TestBatch;  -- Returns rows 1 and 2.
GO

---partially commit
USE AdventureWorks2012;
GO
IF OBJECT_ID(N'TestBatch', N'U') IS NOT NULL
    DROP TABLE TestBatch;
GO
CREATE TABLE TestBatch (Cola INT PRIMARY KEY, Colb CHAR(3));
GO
INSERT INTO TestBatch VALUES (1, 'aaa');
INSERT INTO TestBatch VALUES (2, 'bbb');
INSERT INTO TestBch VALUES (3, 'ccc');  -- Syntax error. Table name error.
GO
SELECT * FROM TestBatch;  -- Returns rows 1 and 2.
GO
