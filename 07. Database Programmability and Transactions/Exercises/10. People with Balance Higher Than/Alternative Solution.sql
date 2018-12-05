CREATE OR ALTER PROC usp_GetHoldersWithBalanceHigherThan(@Amount DECIMAL(15, 2)) AS 
BEGIN
	WITH CTE_AccountHolderBalance(AccountHolderID, Balance) AS (
			SELECT AccountHolderId,
			       SUM(Balance) AS TotalBalance
			  FROM Accounts
		  GROUP BY AccountHolderId)
	SELECT FirstName,
	       LastName
	  FROM AccountHolders AS ah
	  JOIN CTE_AccountHolderBalance AS ct
	    ON ct.AccountHolderID = ah.Id
	 WHERE ct.Balance > @Amount
  ORDER BY ah.LastName, ah.FirstName
END
GO