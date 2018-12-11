CREATE OR ALTER PROC usp_MoveVehicle(@vehicleId INT, @officeId INT)
AS
BEGIN
	DECLARE @currentVehiclesInOffice INT = (SELECT COUNT(Id) FROM Vehicles WHERE OfficeId = @officeId);
	DECLARE @parkingSpotsInOffice INT = (SELECT ParkingPlaces FROM Offices WHERE Id = @officeId)

	IF(@currentVehiclesInOffice < @parkingSpotsInOffice)
	BEGIN
		UPDATE Vehicles
		   SET OfficeId = @officeId
		 WHERE Id = @vehicleId
	END
	ELSE
	BEGIN
		;THROW 51000, 'Not enough room in this office!', 1
	END
END
GO

EXEC usp_MoveVehicle 7, 50;
SELECT OfficeId FROM Vehicles WHERE Id = 7
