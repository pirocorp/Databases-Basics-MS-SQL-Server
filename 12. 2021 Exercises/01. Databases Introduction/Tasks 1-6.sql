CREATE DATABASE [Minions]
GO

USE [Minions]
GO

CREATE TABLE [Minions].[dbo].[Minions](
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(100),
	[Age]INT,
);
GO

CREATE TABLE [Minions].[dbo].[Towns](
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(100),
);
GO

    ALTER TABLE [Minions].[dbo].[Minions]
			ADD [TownId] INT
			 GO

    ALTER TABLE [Minions].[dbo].[Minions]
 ADD CONSTRAINT FK_Minions_Towns
    FOREIGN KEY ([TownId]) 
	 REFERENCES [Towns]
			 GO

INSERT INTO [Minions].[dbo].[Towns]([Name])
	 VALUES ('Sofia'),
			('Plovdiv'),
			('Varna')
		 GO

INSERT INTO [Minions].[dbo].[Minions]([Name], [Age], [TownId])
	 VALUES ('Kevin', 22, 1),
			('Bob', 15, 3),
			('Steward', NULL, 2)
		GO

TRUNCATE TABLE [Minions].[dbo].[Minions]
			GO

DROP TABLE [Minions], [Towns]
		GO