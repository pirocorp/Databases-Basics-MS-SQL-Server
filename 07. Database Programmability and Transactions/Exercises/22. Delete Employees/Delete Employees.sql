CREATE TABLE Deleted_Employees(
	EmployeeId INT IDENTITY,
	FirstName NVARCHAR(64) NOT NULL,
	LastName NVARCHAR(64) NOT NULL,
	MiddleName NVARCHAR(64),
	JobTitle NVARCHAR(64) NOT NULL,
	DepartmentID INT NOT NULL,
	Salary DECIMAL(15, 2) NOT NULL,

	CONSTRAINT PK_Deleted_Employees
	PRIMARY KEY(EmployeeId)
)
GO

CREATE OR ALTER TRIGGER tr_EmployeesDelete ON Employees
           AFTER DELETE
	                 AS
		    INSERT INTO Deleted_Employees
			     SELECT FirstName,
				        LastName,
						MiddleName,
						JobTitle,
						DepartmentID,
						Salary
				   FROM deleted
				     GO

DELETE Employees
 WHERE EmployeeID = 1
    GO

SELECT *
  FROM Deleted_Employees
    GO
