CREATE OR ALTER PROC usp_AssignProject(@emloyeeId INT, @projectID INT)
                  AS
			 DECLARE @CurrentProjectsCount INT = (SELECT COUNT(*) 
                                                    FROM EmployeesProjects
                                                   WHERE EmployeeID = @emloyeeId)
				  IF (@CurrentProjectsCount >= 3)
			   BEGIN 
					 RAISERROR ('The employee has too many projects!', 16, 1)
					    RETURN
			     END
		 INSERT INTO EmployeesProjects
		      VALUES (@emloyeeId, @projectID)
				  GO

BEGIN TRANSACTION

EXEC usp_AssignProject 3, 10

SELECT * 
  FROM EmployeesProjects
 WHERE EmployeeID = 3
ROLLBACK