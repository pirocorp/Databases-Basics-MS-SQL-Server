CREATE OR ALTER PROCEDURE usp_DeleteEmployeesFromDepartment (@departmentId INT) 
AS

--Create collection of employees to be deleted as table of Ids
DECLARE @empIDsToBeDeleted TABLE
(
Id int
)

--Insert IDs of Employees which will be deleted into collection
 INSERT INTO @empIDsToBeDeleted
      SELECT e.EmployeeID
        FROM Employees AS e
       WHERE e.DepartmentID = @departmentId

--Allowing ManagerID to be NULL
 ALTER TABLE Departments
ALTER COLUMN ManagerID INT NULL	   

--DELETING Employees from projects
 DELETE FROM EmployeesProjects
       WHERE EmployeeID IN (SELECT Id FROM @empIDsToBeDeleted)    
 
--Removing Employees as Managers
      UPDATE Employees
         SET ManagerID = NULL
       WHERE ManagerID IN (SELECT Id FROM @empIDsToBeDeleted)    

--Removing Employees as Managers of Departments
      UPDATE Departments
         SET ManagerID = NULL
       WHERE ManagerID IN (SELECT Id FROM @empIDsToBeDeleted)

--DELETING Employees
      DELETE FROM Employees
       WHERE EmployeeID IN (SELECT Id FROM @empIDsToBeDeleted)

--DELETING Department
      DELETE FROM Departments
       WHERE DepartmentID = @departmentId 

--Verifying that there are no left employees in department and returning it as result
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