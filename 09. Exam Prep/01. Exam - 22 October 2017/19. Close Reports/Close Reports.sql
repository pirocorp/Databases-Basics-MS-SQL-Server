CREATE OR ALTER TRIGGER tr_CloseDateInserted ON Reports AFTER UPDATE   
AS
BEGIN
    UPDATE Reports
	   SET StatusId = 3
	 WHERE Id IN (SELECT Id
	                FROM inserted
	               WHERE CloseDate IS NOT NULL)
END 
GO  

UPDATE Reports
SET CloseDate = GETDATE()
WHERE EmployeeId = 5;

SELECT * FROM Reports WHERE EmployeeId = 5;