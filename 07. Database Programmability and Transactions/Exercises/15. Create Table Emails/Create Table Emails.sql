CREATE TABLE NotificationEmails(
	Id INT IDENTITY,
	Recipient INT NOT NULL,
	[Subject] NVARCHAR(64) NOT NULL,
	Body NVARCHAR(128) NOT NULL,

	CONSTRAINT PK_NotificationEmails
	PRIMARY KEY(Id),

	CONSTRAINT FK_NotificationEmails_Recipient_Accounts_Id
	FOREIGN KEY(Recipient)
	REFERENCES Accounts(Id)
)
GO

CREATE OR ALTER TRIGGER tr_LogInsert ON Logs FOR INSERT
                     AS
			INSERT INTO NotificationEmails
				 SELECT AccountId AS [Recipient],
				        CONCAT('Balance change for account: ', AccountId) AS [Subject],
						CONCAT('On ', GETDATE(), ' your balance was changed from ', OldSum, '  to ', NewSum, '.') AS Body
				   FROM inserted
					 GO

UPDATE Accounts
   SET Balance = 123.12
 WHERE Id = 1
    GO

SELECT *
  FROM Logs
    GO

SELECT *
  FROM NotificationEmails
    GO