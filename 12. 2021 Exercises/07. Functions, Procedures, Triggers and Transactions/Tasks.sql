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

