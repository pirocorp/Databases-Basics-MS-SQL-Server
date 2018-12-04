CREATE OR ALTER PROC usp_DepositMoney (@AccountId INT, @MoneyAmount DECIMAL(15, 4))
                  AS
				  IF (@MoneyAmount > 0)
			   BEGIN
					 UPDATE Accounts
					    SET Balance += @MoneyAmount
					  WHERE Id = @AccountId
			     END
				  GO

EXEC usp_DepositMoney 1, 0
  GO

SELECT *
  FROM Accounts
 WHERE Id = 1
    GO

SELECT *
  FROM Logs
    GO

SELECT *
  FROM NotificationEmails
    GO