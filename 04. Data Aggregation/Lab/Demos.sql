USE SoftUni
 GO

--With GROUP BY you can get each separate group and use an "aggregate" function over it (like Average, Min or Max):
  SELECT e.DepartmentID 
    FROM Employees AS e
GROUP BY e.DepartmentID
	  GO

--With DISTINCT you will get all unique values:
SELECT DISTINCT e.DepartmentID   
  FROM Employees AS e
	GO

--Use "SoftUni" database to create a query which prints the total sum of salaries for each department. 
--Order them by DepartmentID (ascending).
--After grouping every employee by it's department we can use aggregate function to calculate total amount of money per group.
  SELECT e.DepartmentID, 
         SUM(e.Salary) AS [Total Salary]
    FROM Employees AS e
GROUP BY e.DepartmentID
ORDER BY e.DepartmentID
	  GO

--Order by DepartmentID but show deprtment name
  SELECT d.[Name], 
         SUM(e.Salary) AS [Total Salary]
    FROM Employees AS e
	JOIN Departments AS d ON(e.DepartmentID = d.DepartmentID)
GROUP BY d.[Name], d.DepartmentID
ORDER BY d.DepartmentID
      GO

--Operate over (non-empty) groups
--Perform data analysis on each one
--MIN, MAX, AVG, COUNT etc.
--Aggregate functions usually ignore NULL values.
  SELECT e.DepartmentID, 
     MIN(e.Salary) AS MinSalary
    FROM Employees AS e
GROUP BY e.DepartmentID
      GO

--COUNT - count the values in one or more grouped columns
--Ignores null values
--COUNT(ColumnName)
--Note: COUNT ignores any employee with NULL salary.
  SELECT e.DepartmentID, 
         COUNT(e.Salary) AS [Salary Count],
		 COUNT(*) AS [Employees Count]
    FROM Employees AS e
GROUP BY e.DepartmentID
	  GO

--If any department has no salaries, it returns NULL.
  SELECT e.DepartmentID,
         SUM(e.Salary) AS TotalSalary
    FROM Employees AS e
GROUP BY e.DepartmentID
	  GO

--MAX - takes the largest value in a column.
  SELECT e.DepartmentID,         
         MAX(e.Salary) AS MaxSalary
    FROM Employees AS e
GROUP BY e.DepartmentID
	  GO

--MIN takes the smallest value in a column. 
  SELECT e.DepartmentID,         
         MIN(e.Salary) AS MinSalary
    FROM Employees AS e
GROUP BY e.DepartmentID
      GO

--AVG calculates the average value in a column. 
  SELECT e.DepartmentID, 
         ROUND(AVG(e.Salary), 2) AS AvgSalary
    FROM Employees AS e
GROUP BY e.DepartmentID
	  GO

--The HAVING clause is used to filter data based on aggregate values 
--We cannot use it without grouping first
--Aggregate functions (MIN, MAX, SUM etc.) are executed only once
--Unlike HAVING, WHERE filters rows before aggregation
  SELECT e.DepartmentID,         
         SUM(e.Salary) AS TotalSalary
    FROM Employees AS e
GROUP BY e.DepartmentID
  HAVING SUM(e.Salary) < 250000
	  GO

--Summarizes data from another table
--Applies an aggregate operation 
--(sorting, averaging, summing, etc…)
--Typically includes grouping of the data. 

USE Incomes
 GO

SELECT * 
  FROM DailyIncome
    GO

SELECT * 
 FROM DailyIncome
PIVOT (
	       AVG(IncomeAmount) FOR IncomeDay 
		   IN ([MON],[TUE],[WED],[THU],[FRI],[SAT],[SUN])
	   ) 
   AS AvgIncomePerDay
   GO