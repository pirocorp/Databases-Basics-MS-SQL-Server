-- Task 1
USE [Gringotts]
GO

SELECT COUNT(*) AS [Count]
  FROM [WizzardDeposits]

-- Task 2
SELECT MAX([MagicWandSize]) AS [LongestMagicWand]
  FROM [WizzardDeposits]

-- Task 3
  SELECT [DepositGroup]
		,MAX([MagicWandSize]) AS [LongestMagicWand]
    FROM [WizzardDeposits]
GROUP BY [DepositGroup]

-- Task 4
  SELECT TOP(2)
		[DepositGroup]
    FROM [WizzardDeposits]
GROUP BY [DepositGroup]
ORDER BY AVG([MagicWandSize])

-- Task 5
  SELECT [DepositGroup]
		,SUM([DepositAmount]) AS [TotalSum]
    FROM [WizzardDeposits]
GROUP BY [DepositGroup]

-- Task 6
  SELECT [DepositGroup]
	    ,SUM([DepositAmount]) AS [TotalSum]
    FROM [WizzardDeposits]
   WHERE [MagicWandCreator] = 'Ollivander family'
GROUP BY [DepositGroup]

-- Task 7
  SELECT [DepositGroup]
	    ,SUM([DepositAmount]) AS [TotalSum]
    FROM [WizzardDeposits]
   WHERE [MagicWandCreator] = 'Ollivander family'
GROUP BY [DepositGroup]
  HAVING SUM([DepositAmount]) < 150000
ORDER BY [TotalSum] DESC

-- Task 8
  SELECT [DepositGroup]
        ,[MagicWandCreator]
        ,MIN([DepositCharge]) AS [MinDepositCharge]
    FROM [WizzardDeposits]
GROUP BY [DepositGroup]
		,[MagicWandCreator]
ORDER BY [MagicWandCreator]
		,[DepositGroup]

-- Task 9
WITH CTE_Ages AS(
SELECT [AgeGroup] = 
			CASE
				WHEN [AGE] BETWEEN 0 AND 10 THEN '[0-10]'
				WHEN [AGE] BETWEEN 11 AND 20 THEN '[11-20]'
				WHEN [AGE] BETWEEN 21 AND 30 THEN '[21-30]'
				WHEN [AGE] BETWEEN 31 AND 40 THEN '[31-40]'
				WHEN [AGE] BETWEEN 41 AND 50 THEN '[41-50]'
				WHEN [AGE] BETWEEN 51 AND 60 THEN '[51-60]'
				ELSE '[61+]'
			END
  FROM [WizzardDeposits]
)

  SELECT [AgeGroup]
		,COUNT(*)
    FROM CTE_Ages
GROUP BY [AgeGroup]

-- Task 10
  SELECT SUBSTRING([FirstName], 1, 1) AS [FirstLetter]
    FROM [WizzardDeposits]
   WHERE [DepositGroup] = 'Troll Chest'
GROUP BY SUBSTRING([FirstName], 1, 1)
ORDER BY [FirstLetter]

-- Task 11
  SELECT [DepositGroup]
		,[IsDepositExpired]
		,AVG([DepositInterest]) AS [AverageInterest]
    FROM [WizzardDeposits]
   WHERE [DepositStartDate] > '01/01/1985'
GROUP BY [DepositGroup]
		,[IsDepositExpired]
ORDER BY [DepositGroup] DESC
		,[IsDepositExpired] ASC

-- Task 12
--  It works but it's a cheat SELECT 44393.97 AS [SumDifference]
SELECT SUM([First].[DepositAmount] - [Second].[DepositAmount]) AS [SumDifference]
  FROM [WizzardDeposits] AS [First]
  JOIN [WizzardDeposits] AS [Second]
    ON [First].[Id] + 1 = [Second].[Id]

-- Task 13
USE [SoftUni]
GO

  SELECT [DepartmentID] 
		,SUM([Salary]) AS [TotalSalary]
    FROM [Employees]
GROUP BY [DepartmentID]

-- Task 14
  SELECT [DepartmentID] 
		,MIN([Salary]) AS [MinimumSalary]
    FROM [Employees]
   WHERE [Employees].[HireDate] > '01/01/2000'
GROUP BY [DepartmentID]
  HAVING [DepartmentID] IN (2, 5, 7)

-- Task 15
SELECT * INTO [EmployeesAS] FROM Employees
WHERE [Salary] > 30000

DELETE FROM [EmployeesAS]
 WHERE [ManagerId] = 42

UPDATE [EmployeesAS]
   SET [Salary] += 5000
 WHERE [DepartmentId] = 1

  SELECT [DepartmentId]
		,AVG([Salary]) AS [AverageSalary]
    FROM [EmployeesAS]
GROUP BY [DepartmentId]

DROP TABLE [EmployeesAS]

-- Task 16
  SELECT [DepartmentID]
	    ,MAX([Salary]) AS [MaxSalary]
    FROM [Employees]
GROUP BY [DepartmentID]
  HAVING MAX([Salary]) NOT BETWEEN 30000 AND 70000

-- Task 17
SELECT COUNT([Salary]) AS [Count]
  FROM [Employees]
 WHERE [ManagerID] IS NULL

-- Task 18
WITH CTE_Salaries AS(
SELECT [DepartmentId]
	 ,[Salary]
	 ,DENSE_RANK() OVER(PARTITION BY [E].[DepartmentID] ORDER BY [E].[Salary] DESC) AS [Rank]
 FROM [Employees] AS [E]
)

SELECT DISTINCT [DepartmentId]
	  ,[Salary]
  FROM CTE_Salaries
 WHERE [Rank] = 3

-- Task 19
WITH CTE_AverageSalary AS(
  SELECT [DepartmentId]
	    ,AVG([Salary]) AS [Average Salary]
    FROM [Employees]
GROUP BY [DepartmentID]
)

  SELECT TOP(10)
		 [E].[FirstName]
  	    ,[E].[LastName]
  	    ,[E].[DepartmentID]
    FROM [Employees] AS [E]
    JOIN [CTE_AverageSalary] AS [C]
      ON [E].[DepartmentID] = [C].[DepartmentID]
   WHERE [E].[Salary] > [C].[Average Salary]
ORDER BY [E].[DepartmentID]