--CTE Solution NULL != 42 evaluates to false (evaluates to null so result is skipped)
	WITH EmployeeSalary
      AS (SELECT DepartmentID,
                 CASE  
                     WHEN  DepartmentID = 1 THEN 5000 + Salary
          		     ELSE Salary
                 END AS [Salary],
          	     ManagerID
            FROM Employees
           WHERE Salary > 30000 AND (ManagerID != 42 OR ManagerID IS NULL))
  SELECT DepartmentID,
         AVG(Salary) AS AverageSalary
    FROM EmployeeSalary
GROUP BY DepartmentID

--Standart Solution
--This create new table and copy all entities from employees for given condition
SELECT * INTO [EmployeesAS] FROM Employees
WHERE [Salary] > 30000

DELETE FROM EmployeesAS
WHERE [ManagerID] = 42
 
UPDATE EmployeesAS
SET [Salary] += 5000
WHERE [DepartmentID] = 1
 
SELECT [DepartmentID],
    AVG([Salary]) as [AverageSalary]
FROM EmployeesAS
GROUP BY [DepartmentID]