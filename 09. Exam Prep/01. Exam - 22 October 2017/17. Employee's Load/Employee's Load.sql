CREATE OR ALTER FUNCTION udf_GetReportsCount(@employeeId INT, @statusId INT)
RETURNS INT
AS
BEGIN
    DECLARE @Result INT = (
	SELECT COUNT (Id)
	  FROM Reports
	 WHERE EmployeeId = @employeeId
	   AND StatusId = @statusId)
	RETURN @Result
END
GO

SELECT Id, FirstName, Lastname, dbo.udf_GetReportsCount(Id, 2) AS ReportsCount
FROM Employees
ORDER BY Id
