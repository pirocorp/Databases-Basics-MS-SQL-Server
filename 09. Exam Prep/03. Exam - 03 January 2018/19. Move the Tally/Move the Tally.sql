CREATE OR ALTER TRIGGER tr_AddMileageOnOrderUpdate ON Orders AFTER UPDATE
AS
BEGIN
	UPDATE Vehicles
	   SET Mileage += (SELECT TotalMileage FROM inserted WHERE VehicleId = inserted.VehicleId)
	 WHERE Id IN (SELECT i.VehicleId
	                FROM inserted AS i
	                JOIN deleted AS d ON d.Id = i.Id
	               WHERE d.TotalMileage IS NULL)
END
GO

UPDATE Orders
SET
TotalMileage = 100
WHERE Id = 16;

SELECT Mileage FROM Vehicles
WHERE Id = 25