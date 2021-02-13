-- Task 1
CREATE DATABASE Bitbucket
GO

USE Bitbucket
GO

CREATE TABLE [Users] (
	[Id] INT PRIMARY KEY IDENTITY
	,[Username] VARCHAR(30) NOT NULL
	,[Password] VARCHAR(30) NOT NULL
	,[Email] VARCHAR(30) NOT NULL
)

CREATE TABLE [Repositories] (
	[Id] INT PRIMARY KEY IDENTITY
	,[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE [RepositoriesContributors] (
	[RepositoryId] INT NOT NULL REFERENCES [Repositories]([Id])
	,[ContributorId] INT NOT NULL REFERENCES [Users]([Id])
	,CONSTRAINT PK_RepositoriesContributors PRIMARY KEY ([RepositoryId], [ContributorId])
)

CREATE TABLE [Issues](
	[Id] INT PRIMARY KEY IDENTITY
	,[Title] VARCHAR(255) NOT NULL
	,[IssueStatus] CHAR(6) NOT NULL
	,[RepositoryId] INT NOT NULL REFERENCES [Repositories]([Id])
	,[AssigneeId] INT NOT NULL REFERENCES [Users]([Id])
)

CREATE TABLE [Commits](
	[Id] INT PRIMARY KEY IDENTITY
	,[Message] VARCHAR(255) NOT NULL
	,[IssueId] INT REFERENCES [Issues]([Id])
	,[RepositoryId] INT NOT NULL REFERENCES [Repositories]([Id])
	,[ContributorId] INT NOT NULL REFERENCES [Users]([Id])
)

CREATE TABLE [Files](
	[Id] INT PRIMARY KEY IDENTITY
	,[Name] VARCHAR(100) NOT NULL
	,[Size] DECIMAL(18, 2) NOT NULL
	,[ParentId] INT REFERENCES [Files]([Id])
	,[CommitId] INT NOT NULL REFERENCES [Commits]([Id])
)

-- Task 2
INSERT INTO [Files] ([Name], [Size], [ParentId], [CommitId])
VALUES ('Trade.idk', 2598.0, 1, 1)
,('menu.net', 9238.31, 2, 2)
,('Administrate.soshy', 1246.93, 3, 3)
,('Controller.php', 7353.15, 4, 4)
,('Find.java', 9957.86, 5, 5)
,('Controller.json', 14034.87, 3, 6)
,('Operate.xix', 7662.92, 7, 7)

INSERT INTO [Issues] ([Title], [IssueStatus], [RepositoryId], [AssigneeId])
VALUES ('Critical Problem with HomeController.cs file', 'open', 1, 4)
,('Typo fix in Judge.html', 'open', 4, 3)
,('Implement documentation for UsersService.cs', 'closed', 8, 2)
,('Unreachable code in Index.cs', 'open', 9, 8)

-- Task 3
UPDATE [Issues]
   SET [IssueStatus] = 'closed'
 WHERE [AssigneeId] = 6

-- Task 4
 DELETE [RepositoriesContributors]
  WHERE [RepositoryId] = (SELECT [Id] FROM [Repositories] WHERE [Name] = 'Softuni-Teamwork')

DELETE [Issues]
 WHERE [RepositoryId] = (SELECT [Id] FROM [Repositories] WHERE [Name] = 'Softuni-Teamwork')

-- Task 5
  SELECT [Id]
		,[Message]
		,[RepositoryId]
		,[ContributorId] 
    FROM [Commits]
ORDER BY [Id]
		,[Message]
		,[RepositoryId]
		,[ContributorId]

-- Task 6
  SELECT [Id]
  	    ,[Name]
  	    ,[Size]
    FROM [Files]
   WHERE [Size] > 1000
     AND [Name] LIKE '%html%'
ORDER BY [Size] DESC
		,[Id] ASC
		,[Name] ASC

-- Task 7
SELECT [I].[Id]
	  ,CONCAT([U].[Username], ' : ', [I].[Title])
  FROM [Issues] AS [I]
  JOIN [Users] AS [U]
    ON [I].[AssigneeId] = [U].[Id]
ORDER BY [I].[Id] DESC
        ,[I].[AssigneeId] ASC

-- Task 8
  SELECT [F].[Id]
  	    ,[F].[Name]
  	    ,CONCAT([F].[Size], 'KB') AS [Size]
    FROM [Files] AS [F]
   WHERE [F].[Id] NOT IN (SELECT DISTINCT [ParentId] AS [Id] FROM [Files] WHERE [ParentId] IS NOT NULL)
ORDER BY [F].[Id] ASC
        ,[F].[Name] ASC
		,[F].[Size] DESC

-- Task 9
  SELECT TOP(5)
		 [R].[Id]
        ,[R].[Name]
  	    ,COUNT(*) AS [Commits]
    FROM [RepositoriesContributors] AS [RC]
    JOIN [Repositories] AS [R]
      ON [RC].[RepositoryId] = [R].[Id]
    JOIN [Commits] AS [C]
      ON [R].[Id] = [C].[RepositoryId]
GROUP BY [R].[Id]
        ,[R].[Name]
ORDER BY [Commits] DESC
		,[R].[Id] ASC
		,[R].[Name] ASC

-- Task 10
  SELECT [U].[Username]
		,AVG([F].[Size]) AS [Size]
    FROM [Files] AS [F]
    JOIN [Commits] AS [C]
      ON [F].[CommitId] = [C].[Id]
    JOIN [Users] AS [U]
      ON [C].[ContributorId] = [U].[Id]
GROUP BY [U].[Username]
ORDER BY [Size] DESC
        ,[U].[Username] ASC
GO

-- Task 11
CREATE FUNCTION  udf_AllUserCommits(@username VARCHAR(30))
RETURNS INT
BEGIN
	DECLARE @result INT =(
	SELECT COUNT(*) 
	  FROM [Commits]
	 WHERE [ContributorId] = (SELECT [Id] FROM [Users] WHERE [Username] = @username))

	RETURN @result
END
GO

SELECT dbo.udf_AllUserCommits('UnderSinduxrein')
GO

-- Task 12
CREATE PROCEDURE usp_SearchForFiles(@fileExtension VARCHAR(100))
AS
	DECLARE @pattern VARCHAR(110) = '%.' + @fileExtension;

	   SELECT [Id]
	   	     ,[Name]
	   	     ,CONCAT([Size], 'KB') AS [Size]
		 FROM [Files] 
	    WHERE [Name] LIKE @pattern
	 ORDER BY [Id] ASC
			 ,[Name] ASC
			 ,[Size] DESC
GO

EXEC usp_SearchForFiles 'txt'