CREATE TABLE Logs(
	LogId INT IDENTITY,
	AccountId INT NOT NULL,
	OldSum MONEY NOT NULL,
	NewSum MONEY NOT NULL,

	CONSTRAINT PK_Logs
	PRIMARY KEY(LogId)
)
GO

CREATE OR ALTER TRIGGER tr_BalanceUpdate ON Accounts FOR UPDATE
            AS
   INSERT INTO Logs
        SELECT i.Id AS [AccountId],
	           d.Balance AS [OldSum],
		       i.Balance AS [NewSum]
	      FROM deleted as d
    INNER JOIN inserted as i
            ON i.Id = d.Id
			GO

BEGIN TRANSACTION
UPDATE Accounts
   SET Balance = 546464
 WHERE Id IN (1, 5)

SELECT *
  FROM Accounts

SELECT * 
  FROM Logs
ROLLBACK
GO