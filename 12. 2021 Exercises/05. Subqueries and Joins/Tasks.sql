-- Task 1
USE SoftUni
GO

  SELECT TOP (5)
		 [EmployeeId]
  	    ,[JobTitle]
  	    ,[Employees].[AddressId]
  	    ,[AddressText]
    FROM [Employees]
    JOIN [Addresses]
      ON [Employees].[AddressID] = [Addresses].[AddressID]
ORDER BY [Employees].[AddressId]

-- Task 2
  SELECT TOP (50)
		 [FirstName]
		,[LastName]		
		,[Towns].[Name] AS [Town]
		,[AddressText]
    FROM [Employees]
	JOIN [Addresses]
	  ON [Employees].[AddressID] = [Addresses].[AddressID]
	JOIN [Towns]
	  ON [Addresses].[TownID] = [Towns].[TownID]
ORDER BY [FirstName]
		,[LastName]

-- Task 3
  SELECT [E].[EmployeeID]
  	    ,[E].[FirstName]
  	    ,[E].[LastName]
  	    ,[D].[Name] AS [DepartmentName]
    FROM [Employees] AS [E]
    JOIN [Departments] AS [D]
      ON [E].[DepartmentID] = [D].[DepartmentID]
   WHERE [D].[Name] = 'Sales'
ORDER BY [E].[EmployeeID]
 
 -- Task 4
  SELECT TOP(5)
		 [E].[EmployeeID]
  	    ,[E].[FirstName]
  	    ,[E].[Salary]
  	    ,[D].[Name] AS [DepartmentName]
    FROM [Employees] AS [E]
    JOIN [Departments] AS [D]
      ON [E].[DepartmentID] = [D].[DepartmentID]
   WHERE [E].[Salary] > 15000
ORDER BY [E].[DepartmentID]

-- Task 5
    SELECT TOP(3)
		   [E].[EmployeeID]
		  ,[E].[FirstName]
      FROM [EmployeesProjects] AS [EP]
RIGHT JOIN [Employees] AS [E]
        ON [EP].[EmployeeID] = [E].[EmployeeID]
	 WHERE [ProjectID] IS NULL
  ORDER BY [E].[EmployeeID]

-- Task 6
  SELECT [E].[FirstName]
  	    ,[E].[LastName]
  	    ,[E].[HireDate]
  	    ,[D].[Name]
    FROM [Employees] AS [E]
    JOIN [Departments] AS [D]
      ON [E].[DepartmentID] = [D].[DepartmentID]
   WHERE [E].[HireDate] > '1999/01/01'
     AND [D].[Name] IN ('Sales', 'Finance')
ORDER BY [E].[HireDate]

-- Task 7
  SELECT TOP (5)
		 [E].[EmployeeID]
  	    ,[E].[FirstName]
		,[P].[Name] AS [ProjectName]
    FROM [Employees] AS [E]
	JOIN [EmployeesProjects] AS [EP]
	  ON [E].[EmployeeID] = [EP].[EmployeeID]
	JOIN [Projects] AS [P]
	  ON [EP].[ProjectID] = [P].[ProjectID]
   WHERE [P].[StartDate] > '2002/08/13'
     AND [P].[EndDate] IS NULL
ORDER BY [E].[EmployeeID]

-- Task 8
  SELECT 
		 [E].[EmployeeID]
  	    ,[E].[FirstName]
		,[ProjectName] = 
			CASE
				WHEN DATEPART(YEAR, [P].[StartDate]) >= 2005 THEN NULL
				ELSE [P].[Name]
			END
    FROM [Employees] AS [E]
	JOIN [EmployeesProjects] AS [EP]
	  ON [E].[EmployeeID] = [EP].[EmployeeID]
	JOIN [Projects] AS [P]
	  ON [EP].[ProjectID] = [P].[ProjectID]
   WHERE [E].[EmployeeID] = 24

-- Task 9
  SELECT [E].[EmployeeID]
  	    ,[E].[FirstName]
		,[E].[ManagerID]
		,[M].[FirstName] AS [ManagerName]
	FROM [Employees] AS [E]
	JOIN [Employees] AS [M]
	  ON [E].[ManagerID] = [M].[EmployeeID]
   WHERE [E].[ManagerID] IN (3, 7)
ORDER BY [E].[EmployeeID]

-- Task 10
  SELECT TOP(50)
         [E].[EmployeeID]
  	    ,CONCAT([E].[FirstName], ' ', [E].[LastName]) AS [EmployeeName]
		,CONCAT([M].[FirstName], ' ', [M].[LastName]) AS [ManagerName]
		,[D].[Name] AS [DepartmentName]
	FROM [Employees] AS [E]
	JOIN [Employees] AS [M]
	  ON [E].[ManagerID] = [M].[EmployeeID]
	JOIN [Departments] AS [D]
	  ON [E].[DepartmentID] = [D].[DepartmentID]
ORDER BY [E].[EmployeeID]

-- Task 11
  SELECT TOP(1)
		 AVG([Salary]) AS [MinAverageSalary]
    FROM [Employees] AS [E]
    JOIN [Departments] AS [D]
      ON [E].[DepartmentID] = [D].[DepartmentID]
GROUP BY [E].[DepartmentID]
ORDER BY [MinAverageSalary]

-- Task 12
USE [Geography]
GO

  SELECT [C].[CountryCode]
  	    ,[M].[MountainRange]
  	    ,[P].[PeakName]
  	    ,[P].[Elevation]
    FROM [Peaks] AS [P]
    JOIN [Mountains] AS [M]
  	ON [P].[MountainId] = [M].[Id]
    JOIN [MountainsCountries] AS [MC]
      ON [M].[Id] = [MC].[MountainId]
    JOIN [Countries] AS [C]
      ON [MC].[CountryCode] = [C].[CountryCode]
   WHERE [C].[CountryName] = 'Bulgaria'
     AND [P].[Elevation] > 2835
ORDER BY [P].[Elevation] DESC

-- Task 13
  SELECT [C].[CountryCode]
		,COUNT(*) AS [MountainRanges]
    FROM [Mountains] AS [M] 
    JOIN [MountainsCountries] AS [MC]
      ON [M].[Id] = [MC].[MountainId]
    JOIN [Countries] AS [C]
      ON [MC].[CountryCode] = [C].[CountryCode]
   WHERE [C].[CountryName] IN ('United States', 'Russia', 'Bulgaria')
GROUP BY [C].[CountryCode]

-- Task 14
   SELECT TOP (5)
          [C].[CountryName]
		 ,[R].[RiverName]
     FROM [Countries] AS [C]
     JOIN [Continents] AS [K]
       ON [C].[ContinentCode] = [K].[ContinentCode]
LEFT JOIN [CountriesRivers] AS [CR]
	   ON [C].[CountryCode] = [CR].[CountryCode]
LEFT JOIN [Rivers] AS [R]
	   ON [CR].[RiverId] = [R].[Id]
    WHERE [K].[ContinentName] = 'Africa'
 ORDER BY [C].[CountryName]

 -- Task 15 
 WITH CTE_Currency AS (
  SELECT [ContinentCode]
        ,[CurrencyCode]
		,COUNT(CurrencyCode) AS [CurrencyUsage]
		,DENSE_RANK() OVER(PARTITION BY [ContinentCode] ORDER BY COUNT([CurrencyCode]) DESC) AS [CurrencyRank]
    FROM [Countries]
GROUP BY [ContinentCode] 
        ,[CurrencyCode]
)

SELECT [ContinentCode]
	  ,[CurrencyCode]
	  ,[CurrencyUsage]
  FROM CTE_Currency
 WHERE CurrencyRank = 1
   AND [CurrencyUsage] > 1

-- Task 16
   SELECT COUNT(*)
     FROM [Countries] AS [C]
LEFT JOIN [MountainsCountries] AS [MC]
	   ON [C].[CountryCode] = [MC].[CountryCode]
	WHERE [MC].[MountainId] IS NULL



-- Task 17
WITH CTE_Peaks_And_Rivers AS (
    SELECT [C].[CountryName]
		  ,[P].[PeakName]
		  ,[P].[Elevation]
		  ,[R].[RiverName]
		  ,[R].[Length]
		  ,DENSE_RANK() OVER(PARTITION BY [CountryName] ORDER BY MAX([Elevation]) DESC) AS [PeakRank]
		  ,DENSE_RANK() OVER(PARTITION BY [CountryName] ORDER BY MAX([Length]) DESC) AS [RiverRank]
      FROM [Countries] AS [C]
 LEFT JOIN [MountainsCountries] AS [MC]
        ON [C].[CountryCode] = [MC].[CountryCode]
 LEFT JOIN [Mountains] AS [M]
        ON [MC].[MountainId] = [M].[Id]
 LEFT JOIN [Peaks] AS [P]
		ON [M].[Id] = [P].[MountainId]
 LEFT JOIN [CountriesRivers] AS [CR]
		ON [C].[CountryCode] = [CR].[CountryCode]
 LEFT JOIN [Rivers] AS [R]
		ON [CR].[RiverId] = [R].[Id]
  GROUP BY [C].[CountryName]
		  ,[P].[PeakName]
		  ,[P].[Elevation] 
		  ,[R].[RiverName]
		  ,[R].[Length]
)

  SELECT TOP(5)
         [CountryName]
    	,[Elevation] AS [HighestPeakElevation]
    	,[Length] AS [LongestRiverLength]
    FROM CTE_Peaks_And_Rivers
   WHERE [PeakRank] = 1
     AND [RiverRank] = 1
ORDER BY [HighestPeakElevation] DESC
        ,[LongestRiverLength] DESC
		,[CountryName]

-- Task 18
WITH CTE_Peaks AS (
   SELECT [CountryName]
		 ,[PeakName]
		 ,[Elevation]
		 ,[MountainRange]
		 ,DENSE_RANK() OVER(PARTITION BY [CountryName] ORDER BY MAX([Elevation]) DESC) AS [PeakRank]
     FROM [Countries] AS [C]
LEFT JOIN [MountainsCountries] AS [MC]
       ON [C].[CountryCode] = [MC].[CountryCode]
LEFT JOIN [Mountains] AS [M]
	   ON [MC].[MountainId] = [M].[Id]
LEFT JOIN [Peaks] AS [P]
	   ON [M].[Id] = [P].[MountainId]
 GROUP BY [CountryName]
		 ,[PeakName]
		 ,[Elevation]
		 ,[MountainRange]
)

   SELECT TOP(5)
          [CountryName]
         ,[Highest Peak Name] = 
   				CASE
   					WHEN [PeakName] IS NULL THEN '(no highest peak)'
   					ELSE [PeakName]
   				END
   	     ,[Highest Peak Elevation] =
   				CASE
   					WHEN [Elevation] IS NULL THEN 0
   					ELSE [Elevation]
   				END
   	     ,[Mountain] = 
   				CASE
   					WHEN [MountainRange] IS NULL THEN '(no mountain)'
   					ELSE [MountainRange]
   				END
     FROM CTE_Peaks
    WHERE [PeakRank] = 1
 ORDER BY [CountryName]
		 ,[Highest Peak Name]