CREATE OR ALTER PROC usp_WithdrawMoney (@AccountId INT, @MoneyAmount DECIMAL(15, 4)) 
                  AS 
				  IF (@MoneyAmount > 0)
			   BEGIN 
			         DECLARE @CurrentAmount DECIMAL(15, 4) = (SELECT Balance
                                                                FROM Accounts
                                                               WHERE Id = @AccountId)
			              IF (@CurrentAmount - @MoneyAmount >= 0)
					   BEGIN
					         UPDATE Accounts
							    SET Balance -= @MoneyAmount
							  WHERE Id = @AccountId
					     END                      
			     END
				  GO

BEGIN TRANSACTION
EXEC usp_WithdrawMoney 1, 500.1199

SELECT Balance
  FROM Accounts
 WHERE Id = 1

ROLLBACK
      GO

SELECT Balance
  FROM Accounts
 WHERE Id = 1
    GO