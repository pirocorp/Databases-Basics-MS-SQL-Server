--CTE Solution  
  WITH SalaryRank AS(SELECT DepartmentID,
                     	    Salary,
                            DENSE_RANK() OVER(PARTITION BY DepartmentID ORDER BY Salary DESC) AS [Rank]
                       FROM Employees)
SELECT DISTINCT DepartmentID,
       Salary AS ThirdHighestSalary
  FROM SalaryRank
 WHERE [Rank] = 3
    GO

--SUB QUERY SOLUTION
 SELECT DepartmentID, 
        (  SELECT DISTINCT Salary 
		     FROM Employees 
            WHERE DepartmentID = e.DepartmentID 
         ORDER BY Salary DESC OFFSET 2 ROWS FETCH NEXT 1 ROWS ONLY) AS ThirdHighestSalary
   FROM Employees e
  WHERE (  SELECT DISTINCT Salary FROM Employees 
            WHERE DepartmentID = e.DepartmentID 
         ORDER BY Salary DESC OFFSET 2 ROWS FETCH NEXT 1 ROWS ONLY) IS NOT NULL
GROUP BY DepartmentID
      GO

--Another SUB Query Solution
SELECT DepartmentID,
       Salary
  FROM (  SELECT DepartmentID,
                 Salary,
        		 DENSE_RANK() OVER(PARTITION BY DepartmentID ORDER BY Salary DESC) AS [Rank]
            FROM Employees
        GROUP BY DepartmentID, 
                 Salary
       ) 
	AS RankedSalaries
 WHERE [Rank] = 3
    GO