CREATE TABLE DeletedOrders(
	OrderId INT, 
	ItemId INT, 
	ItemQuantity INT
)
GO

CREATE TRIGGER tr_DeleteOrderItems ON OrderItems FOR DELETE
AS
BEGIN
	INSERT INTO DeletedOrders(OrderId, ItemId, ItemQuantity)
	SELECT * FROM deleted
END
GO

DELETE FROM OrderItems
WHERE OrderId = 5

DELETE FROM Orders
WHERE Id = 5 
