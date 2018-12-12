CREATE OR ALTER PROC usp_SendFeedback(@customerId INT, @productId INT, @rate DECIMAL(10, 2), @description NVARCHAR(255))
AS
BEGIN
	BEGIN TRANSACTION
	INSERT INTO Feedbacks(CustomerId, ProductId, Rate, [Description])
	VALUES(@customerId, @productId, @rate, @description)

	DECLARE @customerFeedbackCount INT = (SELECT COUNT(Id) FROM Feedbacks WHERE CustomerId = @customerId) 
	IF(@customerFeedbackCount > 3)
	BEGIN
		ROLLBACK
		RAISERROR('You are limited to only 3 feedbacks per product!', 16, 1)
		RETURN
	END
	COMMIT
END
GO