CREATE OR ALTER FUNCTION udf_GetCost(@jobId INT)
RETURNS DECIMAL(15, 2)
AS
BEGIN
	DECLARE @result DECIMAL(15, 2) = (SELECT ISNULL(SUM(p.Price), 0) 
                                        FROM Orders AS o
                                        JOIN OrderParts AS op
                                          ON op.OrderId = o.OrderId
                                        JOIN Parts AS p
                                          ON p.PartId = op.PartId
                                       WHERE JobId = @jobId)
	RETURN @result;
END
GO

SELECT dbo.udf_GetCost(1)
