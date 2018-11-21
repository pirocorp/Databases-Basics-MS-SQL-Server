USE SoftUni

SELECT (FirstName + ' ' + ' ' + MiddleName + ' ' + LastName) AS [Name],
[JobTitle] AS [Job Title],
[HireDate] AS [Hire Date],
[Salary],
[Name] AS [Department Name]
FROM Employees JOIN Departments 
	ON Employees.DepartmentId = Departments.Id