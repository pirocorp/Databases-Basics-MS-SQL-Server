--CTE SOLUTION
    WITH AverageSalaries 
      AS ( SELECT DepartmentID,
                  AVG(Salary) AS AverageSalary
             FROM Employees
         GROUP BY DepartmentID)
  SELECT TOP 10 FirstName,
         LastName,
	     Employees.DepartmentID
    FROM Employees
    JOIN AverageSalaries ON (Employees.DepartmentID = AverageSalaries.DepartmentID)
   WHERE Salary > AverageSalary
ORDER BY DepartmentID
	  GO

--Alternative Solution
SELECT TOP (10) e.FirstName, e.LastName, e.DepartmentID
      FROM Employees AS e
     WHERE e.Salary >(SELECT AVG(e2.Salary)
				        FROM Employees AS e2
				       WHERE e.DepartmentID = e2.DepartmentID)
  ORDER BY e.DepartmentID
        GO