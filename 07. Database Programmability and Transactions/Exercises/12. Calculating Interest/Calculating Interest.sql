CREATE OR ALTER PROC usp_CalculateFutureValueForAccount(@AccountId INT, @interestRate FLOAT)
                  AS
			  SELECT a.Id AS [AccountId],
			         ah.FirstName AS [First Name],
					 ah.LastName AS [Last Name],
					 a.Balance AS [Current Balance],
					 dbo.ufn_CalculateFutureValue(a.Balance, @interestRate, 5)
			    FROM Accounts AS a
		  INNER JOIN AccountHolders AS ah
		          ON ah.Id = a.AccountHolderId
			   WHERE a.Id = @AccountId
				  GO

EXEC usp_CalculateFutureValueForAccount 1, 0.1
  GO