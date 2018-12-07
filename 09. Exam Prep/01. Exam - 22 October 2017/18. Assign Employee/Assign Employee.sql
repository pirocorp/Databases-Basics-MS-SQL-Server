CREATE OR ALTER PROC usp_AssignEmployeeToReport(@employeeId INT, @reportId INT)
AS
BEGIN
	DECLARE @employeeDepartmentId INT = (SELECT DepartmentId 
	                                       FROM Employees
									      WHERE Id = @employeeId);

	DECLARE @reportDepartmentId INT = (SELECT c.DepartmentId 
	                                       FROM Reports AS r
										   JOIN Categories AS c
										     ON c.Id = r.CategoryId
									      WHERE r.Id = @reportId);
	IF(@employeeDepartmentId = @reportDepartmentId)
	BEGIN
		UPDATE Reports
		SET EmployeeId = @employeeId
		WHERE Id = @reportId
	END
	ELSE
	BEGIN
		RAISERROR('Employee doesn''t belong to the appropriate department!', 16, 1)
	END
END
GO

EXEC usp_AssignEmployeeToReport 17, 2;
SELECT EmployeeId FROM Reports WHERE id = 2
