CREATE OR ALTER PROC usp_CancelOrder(@OrderId INT, @CancelDate DATETIME)
AS
BEGIN
	DECLARE @Order INT = (SELECT Id FROM Orders WHERE Id = @OrderId)

	IF(@Order IS NULL)
	BEGIN
		RAISERROR('The order does not exist!', 16, 1)
		RETURN
	END

	DECLARE @OrderDate DATETIME = (SELECT [DateTime] FROM Orders WHERE Id = @OrderId)

	IF(@CancelDate > DATEADD(DAY, 3, @OrderDate))
	BEGIN
		RAISERROR('You cannot cancel the order!', 16, 1)
		RETURN
	END

	DELETE OrderItems
	WHERE OrderId = @OrderId

	DELETE Orders
	 WHERE Id = @OrderId
END
GO


BEGIN TRANSACTION
EXEC usp_CancelOrder 1, '2018-06-02'
SELECT COUNT(*) FROM Orders
SELECT COUNT(*) FROM OrderItems
ROLLBACK

EXEC usp_CancelOrder 1, '2018-06-15'
EXEC usp_CancelOrder 124231, '2018-06-15'
