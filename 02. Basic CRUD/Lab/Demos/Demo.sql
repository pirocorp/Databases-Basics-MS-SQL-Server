USE SoftUni
 GO

SELECT FirstName, LastName, JobTitle 
  FROM Employees
	GO

SELECT * 
  FROM Projects 
 WHERE StartDate = '1/1/2006'
	GO

INSERT 
  INTO Projects(Name, StartDate)
VALUES('Introduction to SQL Course', '1/1/2006')
	GO

SELECT * 
  FROM Projects 
 WHERE StartDate = '1/1/2006'
	GO

UPDATE Projects
   SET EndDate = '8/31/2006'
 WHERE StartDate = '1/1/2006'
	GO

SELECT * 
  FROM Projects 
 WHERE StartDate = '1/1/2006'
	GO

DELETE 
  FROM Projects
 WHERE StartDate = '1/1/2006'
    GO

SELECT * 
  FROM Projects 
 WHERE StartDate = '1/1/2006'
	GO

SELECT * 
  FROM Departments
	GO

SELECT DepartmentId, [Name] 
  FROM Departments
	GO

SELECT EmployeeID AS ID,
       FirstName,
       LastName
  FROM Employees
	GO

SELECT FirstName + ' ' + LastName AS [Full Name],
       EmployeeID AS [No.]
  FROM Employees
	GO

SELECT FirstName + ' ' + LastName
    AS [Full Name],
	   JobTitle,
	   Salary
  FROM Employees
    GO

SELECT DISTINCT DepartmentID
  FROM Employees
	GO

SELECT LastName, DepartmentID 
  FROM Employees 
 WHERE DepartmentID = 1
    GO

SELECT LastName, Salary 
  FROM Employees
 WHERE Salary <= 20000
    GO

SELECT LastName, ManagerID 
  FROM Employees
 WHERE NOT (ManagerID = 3 OR ManagerID = 4)
    GO

SELECT LastName, Salary 
  FROM Employees
 WHERE Salary BETWEEN 20000 AND 22000
    GO

SELECT FirstName, LastName, ManagerID 
  FROM Employees
 WHERE ManagerID IN (109, 3, 16)
    GO

SELECT LastName, ManagerId 
  FROM Employees
 WHERE ManagerId IS NULL
    GO

SELECT LastName, ManagerId 
  FROM Employees
 WHERE ManagerId IS NOT NULL
    GO

  SELECT LastName, HireDate
    FROM Employees
ORDER BY HireDate
	  GO

  SELECT LastName, HireDate
    FROM Employees
ORDER BY HireDate DESC
	  GO

CREATE VIEW v_EmployeesByDepartment AS
SELECT FirstName + ' ' + LastName AS [Full Name],
       Salary
  FROM Employees
    GO

SELECT * 
  FROM v_EmployeesByDepartment
    GO

USE [Geography]
 GO

CREATE VIEW v_HighestPeak AS
 SELECT TOP (1) *
       FROM Peaks
   ORDER BY Elevation DESC
         GO

   USE [Geography]
SELECT * 
  FROM v_HighestPeak
    GO

USE [SoftUni]
SET IDENTITY_INSERT Towns ON
GO

INSERT INTO Towns (TownID, [Name])
     VALUES (34, 'Sofia')
         GO

SET IDENTITY_INSERT Towns OFF
 GO

SELECT * 
  FROM Towns
    GO

INSERT INTO Projects ([Name], StartDate)
     VALUES ('Reflective Jacket', GETDATE())
		 GO

INSERT INTO EmployeesProjects
     VALUES (229, 1),
            (229, 2),
            (229, 3)
		 GO

INSERT INTO Projects ([Name], StartDate)
     SELECT [Name] + ' Restructuring', GETDATE()
       FROM Departments
		 GO

CREATE SEQUENCE seq_Customers_CustomerID AS INT
     START WITH 1
   INCREMENT BY 1
			 GO

SELECT NEXT VALUE FOR seq_Customers_CustomerID
			       GO

DELETE FROM Employees WHERE EmployeeID = 1
         GO

TRUNCATE TABLE Users
			GO

USE SoftUni
 GO

UPDATE Employees
   SET LastName = 'Brown'
 WHERE EmployeeID = 1
	GO

UPDATE Employees
   SET Salary = Salary * 1.10,
       JobTitle = 'Senior ' + JobTitle
 WHERE DepartmentID = 3
    GO

UPDATE Projects
   SET EndDate = GETDATE()
 WHERE EndDate IS NULL
    GO

UPDATE Projects
   SET [Description] = [Name] + ' of personal'
 WHERE [Description] IS NULL
    GO

SELECT *
  FROM Projects
 WHERE StartDate <'1/1/2006'
	GO
