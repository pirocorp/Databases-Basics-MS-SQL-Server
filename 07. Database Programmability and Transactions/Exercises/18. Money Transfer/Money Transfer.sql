CREATE OR ALTER PROC usp_TransferMoney(@SenderId INT, @ReceiverId INT, @Amount DECIMAL(15, 4))
                  AS 
   BEGIN TRANSACTION
                     EXEC usp_WithdrawMoney @SenderId, @Amount
					    IF @@ROWCOUNT <> 1
					 BEGIN
				           ROLLBACK
						   --RAISERROR('Transfer Failed', 16, 1)
						   RETURN
					   END
					  EXEC usp_DepositMoney @ReceiverId, @Amount
					  	IF @@ROWCOUNT <> 1
					 BEGIN
				           ROLLBACK
						   --RAISERROR('Transfer Failed', 16, 2)
						   RETURN
					   END
					COMMIT

BEGIN TRANSACTION
SELECT * 
  FROM Accounts
 WHERE Id IN (1, 2)

EXEC usp_TransferMoney 1, 2, 500

SELECT * 
  FROM Accounts
 WHERE Id IN (1, 2)

ROLLBACK
  GO