CREATE OR ALTER FUNCTION udf_CheckForVehicle(@townName NVARCHAR(50), @seatsNumber INT)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @Result NVARCHAR(MAX) = (SELECT TOP 1 CONCAT(o.[Name], ' - ', m.Model) 
                                           FROM Vehicles AS v
                                           JOIN Models AS m ON m.Id = v.ModelId
                                           JOIN Offices AS o ON o.Id = v.OfficeId
                                           JOIN Towns AS t ON t.Id = o.TownId
                                          WHERE t.[Name] = @townName
                                            AND m.Seats = @seatsNumber
                                       ORDER BY o.[Name] ASC)
	IF(@Result IS NULL)
	BEGIN
		SET @Result = 'NO SUCH VEHICLE FOUND'
	END

	RETURN @Result
END
GO

SELECT dbo.udf_CheckForVehicle('La Escondida', 12) 

