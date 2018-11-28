USE SoftUni
 GO

--This will produce Cartesian product it's like cross join
--All rows in the first table are joined to all rows in the second table
SELECT LastName, 
       [Name] AS DepartmentName
  FROM Employees, 
       Departments
    GO

    SELECT LastName, 
           [Name] AS DepartmentName
      FROM Employees
CROSS JOIN Departments
        GO

--Inner join
--A join of two tables returning only rows matching the join condition
    SELECT * 
      FROM Employees AS e
INNER JOIN Departments AS d
        ON e.DepartmentID = d.DepartmentID
		GO

--Left (or right) outer join
--Returns the results of the inner join as well as unmatched rows from the left 
--(or right) table

--Left Outer Join Syntax
         SELECT * 
           FROM Employees AS e
LEFT OUTER JOIN Departments AS d
             ON e.DepartmentID = d.DepartmentID
			 GO

--Right Outer Join Syntax
          SELECT * 
            FROM Employees AS e
RIGHT OUTER JOIN Departments AS d
              ON e.DepartmentID = d.DepartmentID
			  GO

--Full outer join
--Returns the results of an inner join along with all unmatched rows
--Full Join Syntax
   SELECT * 
     FROM Employees AS e
FULL JOIN Departments AS d
       ON e.DepartmentID = d.DepartmentID
	   GO

--Cross Join Syntax
    SELECT * 
      FROM Employees AS e
CROSS JOIN Departments AS d
        GO

--Addresses with Towns
--Display address information of all employees in "SoftUni" database. 
--Select first 50 employees.
SELECT TOP 50 e.FirstName, 
           e.LastName,
		   t.[Name] AS Town,
		   a.AddressText 
      FROM Employees AS e
INNER JOIN Addresses AS a
        ON a.AddressID = e.AddressID
INNER JOIN Towns AS t
        ON t.TownID = a.TownID
  ORDER BY FirstName, 
           LastName
		GO

--Problem: Sales Employees
--Find all employees that are in the "Sales" department. Use "SoftUni" database.
    SELECT e.EmployeeID,
           e.FirstName,
           e.LastName,
    	   d.[Name] AS DepartmentName
      FROM Employees AS e
INNER JOIN Departments AS d
        ON d.DepartmentID = e.DepartmentID
     WHERE d.[Name] = 'Sales'
	    GO

--Problem: Employees Hired After
--Show all employees that:
--Are hired after 1/1/1999
--Are either in "Sales" or "Finance" department
    SELECT e.FirstName,
           e.LastName,
    	   e.HireDate,
    	   d.[Name] AS DeptName
      FROM Employees AS e
INNER JOIN Departments AS d
        ON d.DepartmentID = e.DepartmentID
     WHERE e.HireDate > '1/1/1999'
	   AND d.[Name] IN ('Sales', 'Finance')
  ORDER BY HireDate ASC
	    GO

--Problem: Employee Summary
--Display information about employee's manager and employee's department .
--Show only the first 50 employees.
--Sort by EmployeeID (ascending).
--Using LEFT JOIN because there can be Employees without managers
SELECT TOP 50
           e.EmployeeID,
           CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
           CONCAT(m.FirstName, ' ', m.LastName) AS ManagerName,
 		   d.[Name] AS DepartmentName
      FROM Employees AS e
 LEFT JOIN Employees AS m
        ON m.EmployeeID = e.ManagerID
 LEFT JOIN Departments AS d
        ON d.DepartmentID = e.DepartmentID
  ORDER BY EmployeeID
        GO

--Subquery Syntax
SELECT * 
  FROM Employees AS e
 WHERE e.DepartmentID IN 
       (
        SELECT d.DepartmentID     
          FROM Departments AS d
         WHERE d.Name = 'Finance'
       )
	GO

--Problem: Min Average Salary
--Display lowest average salary of all departments.
--Calculate average salary for each department.
--Then show the value of smallest one.
  SELECT MIN(AvgSalary) AS MinAverageSalary
    FROM (  
	        SELECT AVG(Salary) AS AvgSalary
              FROM Employees
          GROUP BY DepartmentID
		 ) 
  	  AS AvgSalaries
	  GO

--Common Table Expressions
--Common Table Expressions (CTE) can be considered as "named subqueries".
--They could be used to improve code readability and code reuse.
--Usually they are positioned in the beginning of the query.
  WITH CTE_Employees(FirstName, LastName, DepartmentName)
    AS (
           SELECT e.FirstName, 
		          e.LastName, 
		   	      d.[Name]
             FROM Employees AS e 
        LEFT JOIN Departments AS d 
		       ON d.DepartmentID = e.DepartmentID
       )
SELECT FirstName, LastName, DepartmentName 
  FROM CTE_Employees
    GO

--Indices
--Indices speed up searching of values in a certain column or group of columns.
--Usually implemented as B-trees.
--Indices can be built-in the table (clustered) or stored externally (non-clustered).
--Adding and deleting records in indexed tables is slower!
--Indices should be used for big tables only (e.g. 50 000 rows).
--Clustered index is actually the data itself.
--Very useful for fast execution of WHERE, ORDER BY and GROUP BY clauses.
--Maximum 1 clustered index per table
--If a table has no clustered index, its data rows are stored in an unordered structure (heap).
--Non-Clustered Indexes 
--Useful for fast retrieving a single record or a range of records
--Maintained in a separate structure in the DB
--Tend to be much narrower than the base table
--Can locate the exact record(s) with less I/O
--Has at least one more intermediate level than the clustered index
--Much less valuable if table doesn’t have a clustered index
--A non-clustered index has pointers to the actual data rows 
--(pointers to the clustered index if there is one).
--Indices Syntax
CREATE NONCLUSTERED INDEX IX_Employees_FirstName_LastName
                       ON Employees(FirstName, LastName)
                       GO