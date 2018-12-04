CREATE OR ALTER PROCEDURE usp_DeleteEmployeesFromDepartment (@departmentId INT) 
AS

DECLARE @empIDsToBeDeleted TABLE
(
Id int
)

INSERT INTO @empIDsToBeDeleted
SELECT e.EmployeeID
FROM Employees AS e
WHERE e.DepartmentID = @departmentId

 ALTER TABLE Departments
ALTER COLUMN ManagerID INT NULL	   

DELETE FROM EmployeesProjects
WHERE EmployeeID IN (SELECT Id FROM @empIDsToBeDeleted)    

UPDATE Employees
SET ManagerID = NULL
WHERE ManagerID IN (SELECT Id FROM @empIDsToBeDeleted)    

UPDATE Departments
SET ManagerID = NULL
WHERE ManagerID IN (SELECT Id FROM @empIDsToBeDeleted)

DELETE FROM Employees
WHERE EmployeeID IN (SELECT Id FROM @empIDsToBeDeleted)

DELETE FROM Departments
WHERE DepartmentID = @departmentId 

SELECT COUNT(*) AS [Employees Count] FROM Employees AS e
JOIN Departments AS d
ON d.DepartmentID = e.DepartmentID
WHERE e.DepartmentID = @departmentId
GO

BEGIN TRANSACTION
             EXEC usp_DeleteEmployeesFromDepartment 1
         ROLLBACK
               GO

SELECT *
  FROM Departments
 WHERE DepartmentID = 1

SELECT COUNT(*)
	FROM EmployeesProjects

SELECT *
  FROM Employees
 WHERE DepartmentID = 1
    GO