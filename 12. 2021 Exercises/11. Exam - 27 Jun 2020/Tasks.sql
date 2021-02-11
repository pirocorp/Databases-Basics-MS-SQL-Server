-- Task 1
CREATE DATABASE WMS
GO

USE WMS
GO

CREATE TABLE [Clients](
	[ClientId] INT PRIMARY KEY IDENTITY
	,[FirstName] VARCHAR(50) NOT NULL
	,[LastName] VARCHAR(50) NOT NULL
	,[Phone] NCHAR(12) NOT NULL
)

CREATE TABLE [Mechanics] (
	[MechanicId] INT PRIMARY KEY IDENTITY
	,[FirstName] VARCHAR(50) NOT NULL
	,[LastName] VARCHAR(50) NOT NULL
	,[Address] VARCHAR(255) NOT NULL
)

CREATE TABLE [Models] (
	[ModelId] INT PRIMARY KEY IDENTITY
	,[Name] VARCHAR(50) NOT NULL UNIQUE
)

CREATE TABLE [Jobs] (
	[JobId] INT PRIMARY KEY IDENTITY
	,[ModelId] INT NOT NULL
	,CONSTRAINT FK_Jobs_Models FOREIGN KEY ([ModelId]) REFERENCES [Models]([ModelId])
	,[Status] VARCHAR(11) NOT NULL DEFAULT 'Pending'
	,CONSTRAINT CHK_Jobs_Status CHECK ([Status] IN ('Pending', 'In Progress', 'Finished'))
	,[ClientId] INT NOT NULL
	,CONSTRAINT FK_Jobs_Clients FOREIGN KEY ([ClientId]) REFERENCES [Clients]([ClientId])
	,[MechanicId] INT
	,CONSTRAINT FK_Jobs_Mechanics FOREIGN KEY ([MechanicId]) REFERENCES [Mechanics]([MechanicId]) 
	,[IssueDate] DATETIME2 NOT NULL
	,[FinishDate] DATETIME2
)

CREATE TABLE [Orders](
	[OrderId] INT PRIMARY KEY IDENTITY
	,[JobId] INT NOT NULL
	,CONSTRAINT FK_Orders_Jobs FOREIGN KEY ([JobId]) REFERENCES [Jobs]([JobId])
	,[IssueDate] DATETIME2
	,[Delivered] BIT NOT NULL DEFAULT 0
)

CREATE TABLE [Vendors](
	[VendorId] INT PRIMARY KEY IDENTITY
	,[Name] VARCHAR(50) NOT NULL UNIQUE
)

CREATE TABLE [Parts] (
	[PartId] INT PRIMARY KEY IDENTITY
	,[SerialNumber] VARCHAR(50) NOT NULL UNIQUE
	,[Description] VARCHAR(255)
	,[Price] DECIMAL(14, 2) NOT NULL
	,CONSTRAINT CHK_Parts_Price CHECK ([Price] > 0 AND [Price] <= 9999.99)
	,[VendorId] INT NOT NULL
	,CONSTRAINT FK_Parts_Vendors FOREIGN KEY ([VendorId]) REFERENCES [Vendors]([VendorId])
	,[StockQty] INT NOT NULL DEFAULT 0
	,CONSTRAINT CHK_Parts_StockQty CHECK ([StockQty] >= 0)
)

CREATE TABLE [OrderParts](
	[OrderId] INT NOT NULL
	,CONSTRAINT FK_OrderParts_Orders FOREIGN KEY ([OrderId]) REFERENCES [Orders]([OrderId])
	,[PartId] INT NOT NULL
	,CONSTRAINT FK_OrderParts_PartId FOREIGN KEY ([PartId]) REFERENCES [Parts]([PartId])
	,CONSTRAINT PK_OrderParts_OrderId_PartId PRIMARY KEY ([OrderId],[PartId])
	,[Quantity] INT NOT NULL DEFAULT 1
	,CONSTRAINT CHK_OrderParts_Quantity CHECK ([Quantity] > 0)
)

CREATE TABLE [PartsNeeded] (
	[JobId] INT NOT NULL
	,CONSTRAINT FK_PartsNeeded_Jobs FOREIGN KEY ([JobId]) REFERENCES [Jobs]([JobId])
	,[PartId] INT NOT NULL
	,CONSTRAINT FK_PartsNeeded_Parts FOREIGN KEY ([PartId]) REFERENCES [Parts]([PartId])
	,CONSTRAINT PK_PartsNeeded_JobId_PartId PRIMARY KEY ([JobId],[PartId])
	,[Quantity] INT NOT NULL DEFAULT 1
	,CONSTRAINT CHK_PartsNeeded_Quantity CHECK ([Quantity] > 0)
)

-- Task 2
INSERT INTO [Clients]
VALUES('Teri', 'Ennaco', '570-889-5187')
,('Merlyn', 'Lawler', '201-588-7810')
,('Georgene', 'Montezuma', '925-615-5185')
,('Jettie', 'Mconnell', '908-802-3564')
,('Lemuel', 'Latzke', '631-748-6479')
,('Melodie', 'Knipp', '805-690-1682')
,('Candida', 'Corbley', '908-275-8357')

INSERT INTO [Parts] ([SerialNumber], [Description], [Price], [VendorId])
VALUES('WP8182119', 'Door Boot Seal', 117.86, 2)
,('W10780048', 'Suspension Rod', 42.81, 1)
,('W10841140', 'Silicone Adhesive', 6.77, 4)
,('WPY055980', 'High Temperature Adhesive', 13.94, 3)

-- Task 3
UPDATE [Jobs]
   SET [MechanicId] = (SELECT [MechanicId] FROM [Mechanics] WHERE [FirstName] = 'Ryan' AND [LastName] = 'Harnos')
      ,[Status] = 'In Progress'
 WHERE [Status] = 'Pending'

 -- Task 4
 DELETE [OrderParts]
  WHERE [OrderId] = 19

DELETE [Orders] 
 WHERE [OrderId] = 19

 -- Task 5
  SELECT CONCAT([M].[FirstName], ' ', [M].[LastName]) AS [Mechanic]
  	    ,[J].[Status] AS [Status]
  	    ,[J].[IssueDate] AS [IssueDate]
    FROM [Mechanics] AS [M]
    JOIN [Jobs] AS [J]
      ON [M].[MechanicId] = [J].[MechanicId]
ORDER BY [M].[MechanicId]
		,[J].[IssueDate]
		,[J].[JobId]

-- Task 6
  SELECT 
  	     CONCAT([C].[FirstName], ' ', [C].[LastName]) AS [Client]
  	    ,DATEDIFF(DAY, [J].[IssueDate], '2017/04/24') AS [Days going]
  	    ,[J].[Status] AS [Status]
    FROM [Clients] AS [C]
    JOIN [Jobs] AS [J]
      ON [C].[ClientId] = [J].[ClientId]
   WHERE [J].[Status] != 'Finished'
ORDER BY [Days going] DESC
		,[C].[ClientId] ASC

-- Task 7
   SELECT CONCAT([M].[FirstName], ' ', [M].[LastName]) AS [Mechanic]
		 ,AVG(DATEDIFF(DAY, [J].[IssueDate], [J].[FinishDate])) AS [Average Days]
     FROM [Mechanics] AS [M]
LEFT JOIN [Jobs] AS [J]
	   ON [M].[MechanicId] = [J].[MechanicId]
	WHERE [J].[Status] = 'Finished'
 GROUP BY [M].[FirstName]
		 ,[M].[LastName]
		 ,[M].[MechanicId]
 ORDER BY [M].[MechanicId]

 -- Task 8
WITH CTE_MechanicsWithJobs AS (
   SELECT DISTINCT [J].[MechanicId] 
     FROM [Mechanics] AS [M]
LEFT JOIN [Jobs] AS [J]
       ON [M].[MechanicId] = [J].[MechanicId]
	WHERE [J].[Status] IN ('Pending', 'In Progress')
)

  SELECT CONCAT([M].[FirstName], ' ', [M].[LastName]) AS [Available]
    FROM [Mechanics] AS [M]
   WHERE [M].[MechanicId] NOT IN (SELECT * FROM CTE_MechanicsWithJobs)
ORDER BY [M].[MechanicId]

-- Task 9
    SELECT [J].[JobId]
		  ,[Total] = 
			CASE
				WHEN SUM([P].[Price] * [OP].Quantity) IS NULL THEN 0
				ELSE SUM([P].[Price] * [OP].Quantity)
			END
      FROM [Jobs] AS [J]
 LEFT JOIN [Orders] AS [O]
        ON [J].[JobId] = [O].[JobId]
 LEFT JOIN [OrderParts] AS [OP]
		ON [O].[OrderId] = [OP].[OrderId]
 LEFT JOIN [Parts] AS [P]
		ON [OP].[PartId] = [P].[PartId]
     WHERE [J].[Status] = 'Finished'
  GROUP BY [J].[JobId]
  ORDER BY [Total] DESC
		  ,[J].[JobId]

-- Task 10
	WITH CTE_PartsInventory AS (
	    SELECT [P].[PartId] AS [PartId]
	    	  ,[P].[Description] AS [Description]
	    	  ,SUM([PN].Quantity) AS [Required]
	    	  ,SUM([P].[StockQty]) AS [In Stock]
	    	  ,[Ordered] = 
					CASE 
						WHEN SUM([OP].Quantity) IS NULL THEN 0
						ELSE SUM([OP].Quantity)
					END 
		 FROM [Jobs] AS [J]
		 JOIN [PartsNeeded] AS [PN]
		   ON [J].[JobId] = [PN].[JobId]
 		 JOIN [Parts] AS [P]
 		   ON [PN].[PartId] = [P].[PartId]
	LEFT JOIN [Orders] AS [O]
		   ON [J].[JobId] = [O].[JobId]
	LEFT JOIN [OrderParts] AS [OP]
   		   ON [O].[OrderId] = [OP].[OrderId]
		WHERE [J].[Status] != 'Finished'
	 GROUP BY [P].[PartId]
 			 ,[P].[Description]
)

  SELECT * 
    FROM [CTE_PartsInventory] AS [CTE]
   WHERE [CTE].[Required] > [CTE].[In Stock] + [CTE].[Ordered]
ORDER BY [CTE].[PartId]
GO

-- Task 11
CREATE OR ALTER PROCEDURE usp_PlaceOrder (@jobId INT, @partSerial VARCHAR(50), @quantity INT)
AS
	IF @quantity <= 0
		THROW 50012, 'Part quantity must be more than zero!', 1

	IF (SELECT [JobId] FROM [Jobs] WHERE [JobId] = @jobId) IS NULL
		THROW 50013, 'Job not found!', 1

	IF (SELECT [JobId] FROM [Jobs] WHERE [JobId] = @jobId AND [FinishDate] IS NOT NULL) IS NOT NULL
		THROW 50011, 'This job is not active!', 1

	DECLARE @partId INT
	SET @partId = (SELECT [PartId] FROM [Parts] WHERE [SerialNumber] = @partSerial)

	IF @partId IS NULL
		THROW 50014, 'Part not found!', 1

	DECLARE @orderId INT
	SET @orderId = (SELECT [O].[OrderId] FROM [Orders] AS [O] WHERE [O].[JobId] = @jobId)

	IF (SELECT [IssueDate] FROM [Orders] WHERE [OrderId] = @orderId) IS NULL
			UPDATE [OrderParts] SET [Quantity] += @quantity WHERE [OrderId] = @orderId AND [PartId] = @partId
	ELSE
		INSERT INTO [OrderParts] VALUES(@orderId, @partId, @quantity)
GO

-- Task 12
CREATE FUNCTION [udf_GetCost] (@jobId INT)
RETURNS DECIMAL(14, 2)
AS
BEGIN
	DECLARE @result DECIMAL(14, 2);

	SET @result = (SELECT 
					  [Result] = 
							CASE
								WHEN SUM([OP].[Quantity] * [P].[Price]) IS NULL THEN 0
								ELSE SUM([OP].[Quantity] * [P].[Price])
							END
				  FROM [Jobs] AS [J]
			 LEFT JOIN [Orders] AS [O]
					ON [J].[JobId] = [O].[JobId]
			 LEFT JOIN [OrderParts] AS [OP]
					ON [O].[OrderId] = [OP].[OrderId]
			 LEFT JOIN [Parts] AS [P]
					ON [OP].[PartId] = [P].[PartId]
				 WHERE [J].[JobId] = @jobId
			  GROUP BY [J].[JobId])
	RETURN @result
END
GO

SELECT dbo.udf_GetCost(2)

DROP FUNCTION udf_GetCost
GO

