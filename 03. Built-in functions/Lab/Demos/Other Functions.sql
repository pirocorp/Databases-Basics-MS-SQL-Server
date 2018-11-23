--CAST & CONVERT – convert between data types
--CAST(Data AS NewType)
--CONVERT(NewType, Data)
SELECT CAST(5.5350 AS INT)
SELECT CONVERT(INT, 5.567)
	GO

--ISNULL – swap NULL values with a specified default value
--ISNULL(Data, DefaultValue)
SELECT ISNULL('5', 'IS NULL')
SELECT ISNULL(NULL, 'IS NULL')
	GO

USE SoftUni
 GO

UPDATE Projects
   SET EndDate = NULL
 WHERE ProjectID IN (1, 2, 3)
	GO 

SELECT ProjectID, 
	   [Name],
	   ISNULL(CAST(EndDate AS VARCHAR), 'Not Finished') AS [End Date]
  FROM Projects
	GO

--OFFSET & FETCH – get only specific rows from the result set
--Used in combination with ORDER BY for pagination
 SELECT EmployeeID, FirstName, LastName
    FROM Employees
ORDER BY EmployeeID
  OFFSET 10 ROWS
   FETCH NEXT 5 ROWS ONLY
	  GO
	  
  SELECT EmployeeID, FirstName, LastName
    FROM Employees
ORDER BY EmployeeID
  OFFSET 0 ROWS
   FETCH NEXT 10 ROWS ONLY
	  GO		
