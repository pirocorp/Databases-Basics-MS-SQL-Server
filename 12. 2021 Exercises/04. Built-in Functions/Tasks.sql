-- Task 1
USE SoftUni
GO

SELECT [FirstName]
	   ,[LastName]
  FROM [Employees]
 WHERE [Employees].[FirstName] LIKE 'SA%'

-- Task 2
SELECT [FirstName]
	   ,[LastName]
  FROM [Employees]
 WHERE [Employees].[LastName] LIKE '%ei%'

-- Task 3
SELECT [FirstName]
	   ,[HireDate]
  FROM [Employees]
 WHERE [Employees].[DepartmentID] IN (3, 10)
   AND DATEPART(YEAR, HireDate) BETWEEN 1995 AND 2005

-- Task 4
SELECT [FirstName]
	   ,[LastName]
  FROM [Employees]
 WHERE [Employees].[JobTitle] NOT LIKE '%engineer%'

-- Task 5
  SELECT [Name]
    FROM [Towns]
   WHERE LEN ([Name]) >= 5
     AND LEN ([Name]) <= 6
ORDER BY [Name]

-- Task 6
  SELECT [TownID]
		 ,[Name]
    FROM [Towns]
   WHERE [Name] LIKE 'M%'
      OR [Name] LIKE 'K%'
      OR [Name] LIKE 'B%'
      OR [Name] LIKE 'E%'
ORDER BY [Name]

-- Task 7
  SELECT [TownID]
		 ,[Name]
    FROM [Towns]
   WHERE [Name] NOT LIKE 'R%'
     AND [Name] NOT LIKE 'B%'
     AND [Name] NOT LIKE 'D%'
ORDER BY [Name]

-- Task 8
CREATE VIEW V_EmployeesHiredAfter2000 AS
SELECT [FirstName]
	   ,[LastName]
  FROM [Employees]
 WHERE DATEPART(YEAR, HireDate) > 2000

 -- Task 9
 SELECT [FirstName]
	   ,[LastName]
  FROM [Employees]
 WHERE LEN ([LastName]) = 5

 -- Task 10
  SELECT EmployeeID
		 ,FirstName
		 ,LastName
		 ,Salary		 
         ,DENSE_RANK() OVER (PARTITION BY [Salary] ORDER BY[EmployeeID]) AS [Rank]
    FROM [Employees]
   WHERE [Employees].[Salary] >= 10000
     AND [Employees].[Salary] <= 50000
ORDER BY [Employees].[Salary] DESC

-- Task 11
WITH CTE_EmployeesRank AS (
  SELECT [EmployeeID]
		 ,[FirstName]
		 ,[LastName]
		 ,[Salary]	 
         ,DENSE_RANK() OVER (PARTITION BY [Salary] ORDER BY[EmployeeID]) AS [Rank]
    FROM [Employees]
   WHERE [Employees].[Salary] >= 10000
     AND [Employees].[Salary] <= 50000
)

    SELECT * 
      FROM CTE_EmployeesRank
	 WHERE [Rank] = 2
  ORDER BY [Salary] DESC

-- Task 12
USE [Geography]
GO

  SELECT [CountryName] AS [Country Name]
	     ,[ISOCode] AS [ISO Code]
    FROM [Countries]
   WHERE [CountryName] LIKE '%[a]%[a]%[a]%'
ORDER BY [ISO Code]

-- Task 13
   SELECT [PeakName]
         ,[RiverName] 
	     ,LOWER(CONCAT(([PeakName]), SUBSTRING([RiverName], 2, LEN([RiverName])))) AS [Mix]
     FROM [Peaks]
         ,[Rivers]
    WHERE RIGHT([PeakName], 1) = LEFT([RiverName], 1)
 ORDER BY [Mix]

 -- Task 14
 USE [Diablo]
 GO

  SELECT TOP(50)
		[Name]
	    ,CONVERT(NVARCHAR, [Start], 23) AS [Start]
    FROM [Games]
   WHERE DATEPART(YEAR, [Start]) IN (2011, 2012)
ORDER BY [Start]
         ,[Name]


 -- Task 15
 SELECT [Username]
		,SUBSTRING([Email], CHARINDEX('@', [Email]) + 1, LEN([Email])) AS [Email Provider]
 FROM [Users]
 ORDER BY [Email Provider]
		 ,[Username]

 -- Task 16
  SELECT [Username]
	    ,[IPAddress]
    FROM [Users]
   WHERE [IpAddress] LIKE '___.1%.%.___'
ORDER BY [Username]

-- Task 17
WITH CTE_Games AS(
SELECT [Name] AS [Game]
	   ,DATEPART(HOUR, [Start]) AS [Hour]
	   ,[Duration]
  FROM [Games]
)

  SELECT [Game]
 	    ,[Part of the Day] = 
  			CASE 
  				WHEN [Hour] >= 0 AND [Hour] < 12 THEN 'Morning'
  				WHEN [Hour] >= 12 AND [Hour] < 18 THEN 'Afternoon'
  				ELSE 'Evening'
  			END
  	   ,[Duration] = 
  			CASE 
  				WHEN [Duration] <= 3 THEN 'Extra Short'
  				WHEN [Duration] >= 4 AND [Duration] <= 6 THEN 'Short'
  				WHEN [Duration] > 6 THEN 'Long'
  				ELSE 'Extra Long'
  			END
    FROM CTE_Games
ORDER BY [Game]
		 ,[Duration]
		 ,[Part of the Day]

-- Task 18
USE TEST
GO

CREATE TABLE [Orders](
	[Id] INT PRIMARY KEY IDENTITY,
	[ProductName] NVARCHAR(MAX),
	[OrderDate] DATE
);
GO

INSERT INTO [Orders]
	 VALUES ('Butter', '2016-09-19')
			,('Milk', '2016-09-30')
			,('Cheese', '2016-09-04')
			,('Bread', '2015-12-20')
			,('Tomatoes', '2015-12-30')
		GO

SELECT [ProductName]
	   ,[OrderDate]
	   ,DATEADD(DAY, 3, [OrderDate]) AS [Pay Due]
	   ,DATEADD(MONTH, 1, [OrderDate]) AS [Deliver Due]
  FROM Orders


