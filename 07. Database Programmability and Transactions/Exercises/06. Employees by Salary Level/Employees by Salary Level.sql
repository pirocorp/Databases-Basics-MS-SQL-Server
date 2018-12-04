CREATE OR ALTER PROC usp_EmployeesBySalaryLevel(@SalaryLevel NVARCHAR(8))
                  AS
			  SELECT FirstName,
			         LastName
			    FROM Employees
			   WHERE dbo.ufn_GetSalaryLevel(Salary) = @SalaryLevel
			      GO

EXEC usp_EmployeesBySalaryLevel 'High'
  GO