CREATE OR ALTER TRIGGER tr_DeliveryStatusChanged ON ORDERS AFTER UPDATE
AS
BEGIN
UPDATE Parts
   SET StockQty += (SELECT op.Quantity
	                  FROM Orders AS o
	                  JOIN OrderParts AS op ON op.OrderId = o.OrderId
	                  JOIN Parts AS p ON p.PartId = op.PartId
	                 WHERE o.OrderId IN (SELECT i.OrderId FROM inserted AS i WHERE Delivered = 1)
					   AND p.PartId = Parts.PartId)				   
 WHERE PartId IN (SELECT p.PartId
	                FROM Orders AS o
	                JOIN OrderParts AS op ON op.OrderId = o.OrderId
	                JOIN Parts AS p ON p.PartId = op.PartId
	               WHERE o.OrderId IN (SELECT OrderId FROM inserted WHERE Delivered = 1))
END
GO

UPDATE Orders
SET Delivered = 1
WHERE OrderId = 21


