CREATE OR ALTER FUNCTION udf_GetRating(@productName NVARCHAR(25)) 
RETURNS NVARCHAR(10)
AS
BEGIN
	DECLARE @productAverageRating DECIMAL(15, 6) = (SELECT AVG(Rate) 
                                                     FROM Feedbacks
                                                    WHERE ProductId = (SELECT Id 
													                     FROM Products 
																		WHERE [Name] = @productName));
	DECLARE @productRating NVARCHAR(10);

	IF (@productAverageRating < 5)
	BEGIN
		SET @productRating = 'Bad'
		RETURN @productRating
	END

	IF(@productAverageRating <= 8)
	BEGIN
		SET @productRating = 'Average'
		RETURN @productRating
	END	

	IF(@productAverageRating > 8)
	BEGIN
		SET @productRating = 'Good'
		RETURN @productRating
	END

	SET @productRating = 'No rating'
	RETURN @productRating
END
GO

SELECT TOP 5 Id, Name, dbo.udf_GetRating(Name)
  FROM Products
 ORDER BY Id

