-- Task 1
USE SoftUni
GO
 
CREATE PROCEDURE usp_GetEmployeesSalaryAbove35000 AS
	SELECT [FirstName]
		  ,[LastName]
	  FROM [Employees]
	 WHERE [Salary] > 35000
GO

DROP PROCEDURE usp_GetEmployeesSalaryAbove35000	
GO

-- Task 2
CREATE PROCEDURE usp_GetEmployeesSalaryAboveNumber (@salary DECIMAL(10,2))AS
		SELECT [FirstName]
		  ,[LastName]
	  FROM [Employees]
	 WHERE [Salary] >= @salary
GO

EXEC usp_GetEmployeesSalaryAboveNumber 35000
GO

DROP PROCEDURE usp_GetEmployeesSalaryAboveNumber	
GO

-- Task 3
CREATE PROCEDURE usp_GetTownsStartingWith (@start NVARCHAR(MAX))AS
	SELECT [Name]
	  FROM [Towns]
	 WHERE LEFT([Name], LEN(@start)) = @start
GO

EXEC usp_GetTownsStartingWith 'b'
GO

DROP PROCEDURE usp_GetTownsStartingWith	
GO

-- Task 4
CREATE PROCEDURE usp_GetEmployeesFromTown (@town NVARCHAR(MAX))AS
	SELECT [FirstName]
		  ,[LastName]
	  FROM [Employees] AS [E]
	  JOIN [Addresses] AS [A]
	    ON [E].[AddressID] = [A].[AddressID]
	  JOIN [Towns] AS [T]
	    ON [A].[TownID] = [T].[TownID]
	 WHERE [T].[Name] = @town
GO

EXEC usp_GetEmployeesFromTown 'Sofia'
GO

DROP PROCEDURE usp_GetEmployeesFromTown	
GO

-- Task 5
CREATE FUNCTION ufn_GetSalaryLevel(@Salary MONEY)
	RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @salaryLevel VARCHAR(10)

	IF(@Salary < 30000)
		SET @salaryLevel = 'Low'
	ELSE IF(@Salary > 50000)
		SET @salaryLevel = 'High'
	ELSE
		SET @salaryLevel = 'Average'

	RETURN @salaryLevel
END
GO

SELECT [Salary]
	  ,[dbo].[ufn_GetSalaryLevel]([Salary]) AS [Salary Level]
  FROM [Employees]


DROP FUNCTION ufn_GetSalaryLevel	
GO


-- Task 6
CREATE FUNCTION ufn_GetSalaryLevel(@Salary MONEY)
	RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @salaryLevel VARCHAR(10)

	IF(@Salary < 30000)
		SET @salaryLevel = 'Low'
	ELSE IF(@Salary > 50000)
		SET @salaryLevel = 'High'
	ELSE
		SET @salaryLevel = 'Average'

	RETURN @salaryLevel
END
GO

CREATE PROCEDURE usp_EmployeesBySalaryLevel (@SalaryLevel VARCHAR(10))AS
	SELECT [FirstName]
		  ,[LastName]
      FROM [Employees]
	 WHERE [dbo].[ufn_GetSalaryLevel]([Salary]) = @SalaryLevel
GO

EXEC usp_EmployeesBySalaryLevel 'High'
GO

DROP PROCEDURE usp_EmployeesBySalaryLevel
GO

DROP FUNCTION ufn_GetSalaryLevel	
GO

-- Task 7
CREATE FUNCTION ufn_IsWordComprised(@setOfLetters NVARCHAR(MAX), @word NVARCHAR(MAX))
	RETURNS BIT
AS
BEGIN
	DECLARE @result BIT;
	DECLARE @index INT;
	DECLARE @current_char NVARCHAR(1);
	DECLARE @letters_count INT;

	SET @letters_count = LEN(@setOfLetters);	

	SET @index = 1;
		WHILE(@index <= @letters_count)
			BEGIN
				SET @current_char = SUBSTRING(@setOfLetters, @index, @letters_count);
				
				IF @word LIKE '%' + @current_char + '%'
					SET @word = REPLACE(@word, @current_char, '');
				SET @index += 1;				
			END		
	
	IF LEN(@word) <= 0
		SET @result = 1
	ELSE
		SET @result = 0

	RETURN @result
END
GO

SELECT dbo.ufn_IsWordComprised('oistmiahf', 'Sofia')
SELECT dbo.ufn_IsWordComprised('oistmiahf', 'halves')
SELECT dbo.ufn_IsWordComprised('bobr', 'Rob')
SELECT dbo.ufn_IsWordComprised('pppp', 'Guy')

DROP FUNCTION ufn_IsWordComprised
GO

-- Task 8
CREATE PROCEDURE usp_DeleteEmployeesFromDepartment (@departmentId INT) AS
	DELETE
	  FROM EmployeesProjects
	 WHERE EmployeeID IN (SELECT EmployeeID FROM Employees WHERE DepartmentID = @departmentId)

	 ALTER TABLE Departments
	 ALTER COLUMN ManagerID INT NULL

	 UPDATE Departments
	    SET ManagerID = NULL
      WHERE DepartmentID = @departmentId

	   UPDATE Employees
	    SET ManagerID = NULL
      WHERE ManagerID IN (SELECT EmployeeID FROM Employees WHERE DepartmentID = @departmentId)
	
	DELETE
	  FROM [Employees]
	 WHERE [DepartmentID] = @departmentId

	 DELETE 
	   FROM Departments
	  WHERE [DepartmentID] = @departmentId

	  SELECT COUNT(*)
	    FROM [Employees]
		WHERE [DepartmentID] = @departmentId
GO

DROP PROCEDURE usp_DeleteEmployeesFromDepartment
GO

-- Task 9
USE Bank
GO

CREATE PROCEDURE usp_GetHoldersFullName AS
	SELECT CONCAT([FirstName], ' ', [LastName]) AS [Full Name]		  
	  FROM [AccountHolders]
GO

DROP PROCEDURE usp_GetHoldersFullName
GO

-- Task 10
CREATE PROCEDURE usp_GetHoldersWithBalanceHigherThan (@amount DECIMAL(14, 2))AS
  SELECT [FirstName]
		,[LastName]
    FROM [AccountHolders] AS [H]
    JOIN [Accounts] AS [A]
      ON [H].[Id] = [A].[AccountHolderId]
GROUP BY [H].[FirstName]
		,[H].[LastName]
  HAVING SUM([Balance]) > @amount
ORDER BY [FirstName]
		,[LastName]
GO

DROP PROCEDURE usp_GetHoldersWithBalanceHigherThan
GO

-- Taks 11
CREATE FUNCTION ufn_CalculateFutureValue (@sum DECIMAL(14, 2), @interest FLOAT, @years INT)
RETURNS DECIMAL(16, 4)
AS
BEGIN
	DECLARE @result DECIMAL(16, 4)
		SET @result = @sum * POWER((1 + @interest), @years)
	RETURN @result
END
GO

SELECT dbo.ufn_CalculateFutureValue(1000, 0.1, 5)

DROP FUNCTION ufn_CalculateFutureValue
GO

-- Task 12
CREATE FUNCTION ufn_CalculateFutureValue (@sum DECIMAL(14, 2), @interest FLOAT, @years INT)
RETURNS DECIMAL(16, 4)
AS
BEGIN
	DECLARE @result DECIMAL(16, 4)
		SET @result = @sum * POWER((1 + @interest), @years)
	RETURN @result
END
GO

CREATE PROCEDURE usp_CalculateFutureValueForAccount (@accountId INT, @interest FLOAT) AS
	SELECT [A].[Id] AS [Account Id]
		  ,[AH].[FirstName] AS [First Name]
		  ,[AH].[LastName] AS [Last Name]
		  ,[A].[Balance] AS [Current Balance]
		  ,dbo.ufn_CalculateFutureValue([A].[Balance], @interest, 5) AS [Balance in 5 years]
	  FROM [Accounts] AS [A]
	  JOIN [AccountHolders] AS [AH]
	    ON [A].[AccountHolderId] = [AH].[Id]
	 WHERE [A].[Id] = @accountId
GO

EXEC dbo.usp_CalculateFutureValueForAccount 1, 0.1
GO

DROP PROCEDURE usp_CalculateFutureValueForAccount
GO

DROP FUNCTION ufn_CalculateFutureValue
GO

-- Task 13
USE Diablo
GO

CREATE FUNCTION ufn_CashInUsersGames (@game_name NVARCHAR(MAX))
RETURNS TABLE AS
RETURN
(
	WITH CTE_GAME_CASH AS (
		SELECT [UG].[Cash]
			  ,ROW_NUMBER() OVER(ORDER BY [UG].[Cash] DESC) AS [ROW]
		  FROM [UsersGames] AS [UG]
		  JOIN [Games] AS [G]
			ON [UG].[GameId] = [G].[Id]
		 WHERE [G].[Name] = @game_name
	 )

	 SELECT SUM([Cash]) AS [SumCash]
	   FROM CTE_GAME_CASH
	  WHERE [ROW] % 2 = 1
)
GO

SELECT * FROM dbo.ufn_CashInUsersGames('Love in a mist')
GO

DROP FUNCTION ufn_CashInUsersGames
GO

-- Task 14
USE Bank
GO

CREATE TABLE Logs(
	LogId INT PRIMARY KEY IDENTITY,
	AccountId INT,
	OldSum DECIMAL(14, 2),
	NewSum DECIMAL(14, 2)
);
GO

CREATE TRIGGER tr_AddToLogsOnAccountUpdate
ON Accounts FOR UPDATE
AS
	INSERT INTO [Logs]
	SELECT [d].[Id] AS [AccountId]
		  ,[d].[Balance] AS [OldSum]
		  ,[i].[Balance] AS [NewSum]
	  FROM [deleted] AS [d]
	  JOIN [inserted] AS [i]
		ON [d].[Id] = [i].[Id]
GO

DROP TRIGGER tr_AddToLogsOnAccountUpdate
GO

-- Task 15
CREATE TRIGGER tr_AddToLogsOnAccountUpdate
ON Accounts FOR UPDATE
AS
	INSERT INTO [Logs]
	SELECT [d].[Id] AS [AccountId]
		  ,[d].[Balance] AS [OldSum]
		  ,[i].[Balance] AS [NewSum]
	  FROM [deleted] AS [d]
	  JOIN [inserted] AS [i]
		ON [d].[Id] = [i].[Id]
GO

CREATE TABLE NotificationEmails(
	[Id] INT PRIMARY KEY IDENTITY,
	[Recipient] INT,
	[Subject] NVARCHAR(MAX),
	[Body] NVARCHAR(MAX)
);
GO

CREATE TRIGGER tr_AddNotificationEmailOnAccountUpdate
ON Logs FOR INSERT
AS
	INSERT INTO [NotificationEmails]
	SELECT [AccountId] AS [RecipientId]
		  ,CONCAT('Balance change for account: ', [AccountId]) AS [Subject]
		  ,CONCAT('On ', CONVERT(varchar, GETDATE(), 0), ' your balance was changed from ', [OldSum], ' to ', [NewSum], '.') AS [Body]
	  FROM [inserted]
GO

SELECT * 
  FROM [Logs]

SELECT * 
  FROM [NotificationEmails]

SELECT * FROM Accounts

UPDATE [Accounts]
   SET [Balance] += 1000
 WHERE [AccountHolderId] = 2
    GO

SELECT * 
  FROM [Logs]

SELECT * 
  FROM [NotificationEmails]

DROP TRIGGER tr_AddNotificationEmailOnAccountUpdate
GO

DROP TRIGGER tr_AddToLogsOnAccountUpdate
GO

-- Task 16
CREATE PROCEDURE usp_DepositMoney (@AccountId INT, @MoneyAmount DECIMAL(16, 4)) AS
IF @MoneyAmount > 0
	UPDATE [Accounts]
	   SET [Balance] += @MoneyAmount
	 WHERE [Accounts].[Id] = @AccountId
GO

SELECT * FROM Accounts WHERE Id = 1

EXEC dbo.usp_DepositMoney 1, 10

SELECT * FROM Accounts WHERE Id = 1

DROP PROCEDURE usp_DepositMoney
GO

-- Task 17
CREATE PROCEDURE usp_WithdrawMoney (@AccountId INT, @MoneyAmount DECIMAL(16, 4)) AS
IF @MoneyAmount > 0
	UPDATE [Accounts]
	   SET [Balance] -= @MoneyAmount
	 WHERE [Accounts].[Id] = @AccountId
GO

DROP PROCEDURE usp_WithdrawMoney
GO

-- Task 18
CREATE PROCEDURE usp_DepositMoney (@AccountId INT, @MoneyAmount DECIMAL(16, 4)) AS
IF @MoneyAmount > 0
	UPDATE [Accounts]
	   SET [Balance] += @MoneyAmount
	 WHERE [Accounts].[Id] = @AccountId
GO

CREATE PROCEDURE usp_WithdrawMoney (@AccountId INT, @MoneyAmount DECIMAL(16, 4)) AS
IF @MoneyAmount > 0
	UPDATE [Accounts]
	   SET [Balance] -= @MoneyAmount
	 WHERE [Accounts].[Id] = @AccountId
GO

CREATE PROCEDURE usp_TransferMoney(@SenderId INT, @ReceiverId INT, @Amount DECIMAL(16, 4)) AS
	BEGIN TRANSACTION
		IF @Amount < 0
		BEGIN
			ROLLBACK
			RETURN
		END
		
	EXEC dbo.usp_DepositMoney @ReceiverId, @Amount
	EXEC dbo.usp_WithdrawMoney @SenderId, @Amount			
	COMMIT
GO

SELECT * FROM Accounts WHERE Id IN (1, 5)
GO

EXEC usp_TransferMoney 1, 5, 5000

SELECT * FROM Accounts WHERE Id IN (1, 5)
GO

DROP PROCEDURE usp_DepositMoney
GO

DROP PROCEDURE usp_WithdrawMoney
GO

DROP PROCEDURE usp_TransferMoney
GO
-- Task 19
USE Diablo
GO

CREATE TRIGGER tr_UserGameItemsUpdate
ON [UserGameItems] INSTEAD OF INSERT
AS
	INSERT INTO [UserGameItems]
	SELECT [UGI].[ItemId]
		  ,[UGI].[UserGameId]
	  FROM [inserted] AS [UGI]
	  JOIN [Items] AS [I]
        ON [UGI].[ItemId] = [I].[Id]
      JOIN [UsersGames] AS [UG]
        ON [UGI].[UserGameId] = [UG].[Id]
	 WHERE [I].[MinLevel] <= [UG].[Level]
GO

INSERT INTO UserGameItems VALUES (1, 5)

SELECT * FROM UserGameItems WHERE ItemId = 1

SELECT [UGI].[ItemId]
	  ,[UGI].[UserGameId]
	  ,[I].[MinLevel] AS [ItemLevel]
	  ,[UG].[Level] AS [CharacterLevel]
  FROM [UserGameItems] AS [UGI]
  JOIN [Items] AS [I]
    ON [UGI].[ItemId] = [I].[Id]
  JOIN [UsersGames] AS [UG]
    ON [UGI].[UserGameId] = [UG].[Id]
 WHERE ItemId = 1


DROP TRIGGER tr_UserGameItemsUpdate
GO

BEGIN TRANSACTION

SELECT *
  FROM [UsersGames]
 WHERE [UsersGames].[UserId] IN (SELECT [Id] FROM [Users] WHERE [Username] IN ('baleremuda', 'loosenoise', 'inguinalself', 'buildingdeltoid', 'monoxidecos'))
   AND [UsersGames].[GameId] IN (SELECT [Id] FROM [Games] WHERE [Name] = 'bali')

UPDATE [UsersGames]
   SET [Cash] += 5000
 WHERE [UsersGames].[UserId] IN (SELECT [Id] FROM [Users] WHERE [Username] IN ('baleremuda', 'loosenoise', 'inguinalself', 'buildingdeltoid', 'monoxidecos'))
   AND [UsersGames].[GameId] IN (SELECT [Id] FROM [Games] WHERE [Name] = 'bali')

SELECT *
  FROM [UsersGames]
 WHERE [UsersGames].[UserId] IN (SELECT [Id] FROM [Users] WHERE [Username] IN ('baleremuda', 'loosenoise', 'inguinalself', 'buildingdeltoid', 'monoxidecos'))
   AND [UsersGames].[GameId] IN (SELECT [Id] FROM [Games] WHERE [Name] = 'bali')

ROLLBACK
GO

BEGIN TRANSACTION
DECLARE @ItemId AS INT
DECLARE @UserGameId AS INT
SET @ItemId = 251;

CREATE TABLE #NewItems(
	[ItemId] INT,
	[UserGameId] INT
)

WHILE @ItemId <= 299
BEGIN
	INSERT INTO #NewItems
	SELECT @ItemId AS [ItemId]
		  ,[UsersGames].[Id] AS [UserGameId]
	  FROM [UsersGames]
	 WHERE [UsersGames].[UserId] IN (SELECT [Id] FROM [Users] WHERE [Username] IN ('baleremuda', 'loosenoise', 'inguinalself', 'buildingdeltoid', 'monoxidecos'))
	   AND [UsersGames].[GameId] IN (SELECT [Id] FROM [Games] WHERE [Name] = 'bali')	

	SET @ItemId += 1;
END;

SET @ItemId = 501;

WHILE @ItemId <= 539
BEGIN
	INSERT INTO #NewItems
	SELECT @ItemId AS [ItemId]
		  ,[UsersGames].[Id] AS [UserGameId]
	  FROM [UsersGames]
	 WHERE [UsersGames].[UserId] IN (SELECT [Id] FROM [Users] WHERE [Username] IN ('baleremuda', 'loosenoise', 'inguinalself', 'buildingdeltoid', 'monoxidecos'))
	   AND [UsersGames].[GameId] IN (SELECT [Id] FROM [Games] WHERE [Name] = 'bali')	

	SET @ItemId += 1;
END;

SELECT * 
  FROM [UsersGames]
 WHERE [UsersGames].[UserId] IN (SELECT [Id] FROM [Users] WHERE [Username] IN ('baleremuda', 'loosenoise', 'inguinalself', 'buildingdeltoid', 'monoxidecos'))
   AND [UsersGames].[GameId] IN (SELECT [Id] FROM [Games] WHERE [Name] = 'bali')	

UPDATE [UsersGames]
   SET [Cash] -= (SELECT SUM(Price) AS [SUM]
					FROM Items
				   WHERE Items.Id IN (SELECT DISTINCT ItemId FROM #NewItems))
 WHERE [Id] IN (SELECT DISTINCT UserGameId FROM #NewItems)

 INSERT INTO [UserGameItems]
 SELECT * FROM [#NewItems]

DROP TABLE #NewItems

SELECT * 
  FROM [UsersGames]
 WHERE [UsersGames].[UserId] IN (SELECT [Id] FROM [Users] WHERE [Username] IN ('baleremuda', 'loosenoise', 'inguinalself', 'buildingdeltoid', 'monoxidecos'))
   AND [UsersGames].[GameId] IN (SELECT [Id] FROM [Games] WHERE [Name] = 'bali')	
ROLLBACK
GO

   SELECT [U].[Username]
    	 ,[G].[Name]
    	 ,[UG].[Cash]
    	 ,[I].[Name]
     FROM [Users] AS [U]
     JOIN [UsersGames] AS [UG]
       ON [U].[Id] = [UG].[UserId]
     JOIN [Games] AS [G]
       ON [UG].[GameId] = [G].[Id]
     JOIN [UserGameItems] AS [UGI]
       ON [UG].[Id] = [UGI].[UserGameId]
     JOIN [Items] AS [I]
       ON [UGI].[ItemId] = [I].[Id]
    WHERE [G].[Name] = 'Bali'
 ORDER BY [U].[Username]
         ,[I].[Name]
GO

-- Task 20
DECLARE @StamatGameId INT
SET @StamatGameId = (
    SELECT Id 
	  FROM [UsersGames]
	 WHERE [UserId] = (SELECT [Id] FROM [Users] WHERE [Username] = 'Stamat')
	   AND [GameId] = (SELECT [Id] FROM [Games] WHERE [Name] = 'Safflower')
)

DECLARE @RequiredAmount Money
DECLARE @Cache_Amount Money

SET @RequiredAmount = (SELECT SUM(Price)
						    FROM [Items]
						WHERE [MinLevel] >= 11
							AND [MinLevel] <= 12
							AND [Id] NOT IN (SELECT ItemId 
											    FROM [UserGameItems] AS [UGI]
											WHERE [UserGameId] = @StamatGameId))

SET @Cache_Amount = (SELECT Cash FROM UsersGames WHERE Id = @StamatGameId)

IF @Cache_Amount >= @RequiredAmount
BEGIN
	BEGIN TRANSACTION
		UPDATE UsersGames
			SET Cash -= @RequiredAmount
			WHERE Id = @StamatGameId

			INSERT INTO UserGameItems
			SELECT Id, @StamatGameId
			FROM [Items]
			WHERE [MinLevel] >= 11
			AND [MinLevel] <= 12
			AND [Id] NOT IN (SELECT ItemId 
								FROM [UserGameItems] AS [UGI]
								WHERE [UserGameId] = @StamatGameId)
	COMMIT
END

SET @RequiredAmount = (SELECT SUM(Price)
						FROM [Items]
					WHERE [MinLevel] >= 19
						AND [MinLevel] <= 21
						AND [Id] NOT IN (SELECT ItemId 
											FROM [UserGameItems] AS [UGI]
										WHERE [UserGameId] = @StamatGameId))

SET @Cache_Amount = (SELECT Cash FROM UsersGames WHERE Id = @StamatGameId)

IF @Cache_Amount >= @RequiredAmount
BEGIN
	BEGIN TRANSACTION
		UPDATE UsersGames
			SET Cash -= @RequiredAmount
			WHERE Id = @StamatGameId

			INSERT INTO UserGameItems
			SELECT Id, @StamatGameId
			FROM [Items]
			WHERE [MinLevel] >= 19
			AND [MinLevel] <= 21
			AND [Id] NOT IN (SELECT ItemId 
								FROM [UserGameItems] AS [UGI]
								WHERE [UserGameId] = @StamatGameId)
	COMMIT
END

  SELECT [I].[Name] AS [Item Name]
    FROM [UserGameItems] AS [UGI]
    JOIN [Items] AS [I]
      ON [UGI].[ItemId] = [I].[Id]
   WHERE [UGI].[UserGameId] = @StamatGameId
ORDER BY [I].[Name]

-- Task 21
USE SoftUni
GO

CREATE PROCEDURE usp_AssignProject(@emloyeeId INT, @projectID INT)
AS
	DECLARE @proectsCount INT
	SET @proectsCount = (SELECT COUNT(*) 
						   FROM [EmployeesProjects] AS [EP]
						  WHERE EmployeeID = @emloyeeId)

	IF @proectsCount >= 3
	BEGIN
		RAISERROR ('The employee has too many projects!', 16, 1)
		RETURN
	END

	INSERT INTO EmployeesProjects
	     VALUES (@emloyeeId, @projectID)
GO

DROP PROCEDURE usp_AssignProject
GO

-- Task 22
CREATE TABLE Deleted_Employees(
	EmployeeId INT PRIMARY KEY,
	FirstName VARCHAR(50),
	LastName VARCHAR(50),
	MiddleName VARCHAR(50),
	JobTitle VARCHAR(50),
	DepartmentId INT,
	Salary MONEY
)

CREATE TRIGGER tr_EmployeesDelete ON Employees FOR DELETE
AS
	INSERT INTO Deleted_Employees(FirstName, LastName, MiddleName, JobTitle, DepartmentId, Salary)
	SELECT FirstName
		  ,LastName
		  ,MiddleName
		  ,JobTitle
		  ,DepartmentId
		  ,Salary
	 FROM deleted
GO