CREATE PROCEDURE usp_DepositMoney (@accountId INT, @moneyAmount DECIMAL(15, 4)) AS
BEGIN
	BEGIN TRANSACTION

	IF(@moneyAmount <= 0)
	BEGIN
		--RAISERROR('Amount cannot be zero or negative!', 16, 1);
		ROLLBACK;
		RETURN;
	END

	UPDATE Accounts
	SET Balance += @moneyAmount
	WHERE Id = @accountId

	IF(@@ROWCOUNT <> 1)
	BEGIN
		RAISERROR('Invalid account!', 16, 1);
		ROLLBACK;
		RETURN;
	END

	COMMIT
END