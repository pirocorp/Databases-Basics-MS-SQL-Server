CREATE VIEW v_ClientBalances AS
SELECT (Firstname + ' ' + Lastname) AS [Name],
(AccountTypes.Name) AS [AccountType],
Balance
FROM Clients
JOIN Accounts ON Clients.Id = Accounts.ClientId
JOIN AccountTypes ON AccountTypes.Id = Accounts.AccountTypeId