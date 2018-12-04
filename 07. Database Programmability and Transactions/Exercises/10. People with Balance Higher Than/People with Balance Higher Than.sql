CREATE OR ALTER PROC usp_GetHoldersWithBalanceHigherThan(@Amount DECIMAL(15, 2))
                  AS
			  SELECT FirstName,
			         LastName
			    FROM Accounts AS a
		  INNER JOIN AccountHolders AS ah
		          ON ah.Id = a.AccountHolderId
            GROUP BY FirstName,
			         LastName
			  HAVING SUM(Balance) > @Amount
				  GO

EXEC usp_GetHoldersWithBalanceHigherThan 50000
  GO