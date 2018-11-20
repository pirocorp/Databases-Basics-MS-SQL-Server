CREATE FUNCTION f_CalculateTotalBalance(@ClientId INT)
RETURNS DECIMAL(15, 2)
BEGIN
	DECLARE @result AS DECIMAL(15, 2) = (
		SELECT SUM(Balance)
		FROM Accounts WHERE ClientId = @ClientId
	)
	RETURN @result
END