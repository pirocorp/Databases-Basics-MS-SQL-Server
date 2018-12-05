CREATE OR ALTER PROCEDURE UDP_Cursor_Test AS
BEGIN
	DECLARE @EmployeeID INT;
	DECLARE @ProjectID INT;

	DECLARE myCursor CURSOR	FOR 
	SELECT TOP 5 ep.EmployeeID,
	       ep.ProjectID
	  FROM EmployeesProjects AS ep
	
	OPEN myCursor

	FETCH NEXT FROM myCursor INTO @EmployeeID, @ProjectID

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT @EmployeeID, @ProjectID
		FETCH NEXT FROM myCursor INTO @EmployeeID, @ProjectID
	END

	CLOSE myCursor
	DEALLOCATE myCursor
END

EXEC UDP_Cursor_Test