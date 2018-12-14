CREATE OR ALTER FUNCTION udf_GetPromotedProducts(@CurrentDate DATETIME, @StartDate DATETIME, 
@EndDate DATETIME, @Discount DECIMAL(15, 4), @FirstItemId INT, @SecondItemId INT, @ThirdItemId INT)
RETURNS NVARCHAR(MAX)
AS
BEGIN	
	DECLARE @FirstItem INT = (SELECT Id FROM Items WHERE Id = @FirstItemId),
	        @SecondItem INT = (SELECT Id FROM Items WHERE Id = @SecondItemId),
			@ThirdItem INT = (SELECT Id FROM Items WHERE Id = @ThirdItemId),
			@Result NVARCHAR(MAX);

	IF(@FirstItem IS NULL OR @SecondItem IS NULL OR @ThirdItem IS NULL)
	BEGIN
		SET @Result = 'One of the items does not exists!';
		RETURN @Result;
	END

	IF(@StartDate > @CurrentDate OR @EndDate < @CurrentDate)
	BEGIN
		SET @Result = 'The current date is not within the promotion dates!';
		RETURN @Result;
	END

	SET @Discount /= 100;

	SET @Result = (SELECT CONCAT([Name], ' price: ', CONVERT(DECIMAL(15, 2), ROUND(Price - (Price * @Discount), 2))) FROM Items WHERE Id = @FirstItemId);
	SET @Result += ' <-> ';
	SET @Result += (SELECT CONCAT([Name], ' price: ', CONVERT(DECIMAL(15, 2), ROUND(Price - (Price * @Discount), 2))) FROM Items WHERE Id = @SecondItemId);
	SET @Result += ' <-> ';
	SET @Result += (SELECT CONCAT([Name], ' price: ', CONVERT(DECIMAL(15, 2), ROUND(Price - (Price * @Discount), 2))) FROM Items WHERE Id = @ThirdItemId);

	RETURN @Result
END
GO

SELECT dbo.udf_GetPromotedProducts('2018-08-02', '2018-08-01', '2018-08-03',13, 36666,4,5)
GO

SELECT dbo.udf_GetPromotedProducts('2018-08-01', '2018-08-02', '2018-08-03',13,3 ,4,5)
GO