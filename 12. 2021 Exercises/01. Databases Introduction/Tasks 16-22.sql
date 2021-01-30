-- Task 16

CREATE DATABASE [SoftUni]
GO

USE [SoftUni]
GO

CREATE TABLE [Towns](
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(MAX) NOT NULL
);
GO

CREATE TABLE [Addresses](
	[Id] INT PRIMARY KEY IDENTITY,
	[AddressText] NVARCHAR(MAX) NOT NULL,
	[TownId] INT NOT NULL,
	CONSTRAINT FK_Addresses_Towns FOREIGN KEY ([TownId]) REFERENCES [Towns] ([Id])
);
GO

CREATE TABLE [Departments](
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(MAX) NOT NULL
);
GO

CREATE TABLE [Employees] (
	[Id] INT PRIMARY KEY IDENTITY,
	[FirstName] NVARCHAR(MAX) NOT NULL,
	[MiddleName] NVARCHAR(MAX),
	[LastName] NVARCHAR(MAX) NOT NULL,
	[JobTitle] NVARCHAR(MAX),
	[DepartmentId] INT NOT NULL,
	CONSTRAINT FK_Employees_Departments FOREIGN KEY ([DepartmentId]) REFERENCES [Departments] ([Id]),
	[HireDate] DATE,
	[Salary] DECIMAL(6, 2),
	[AddressId] INT,
	CONSTRAINT FK_Employees_Addresses FOREIGN KEY ([AddressId]) REFERENCES [Addresses] ([Id])
);
GO

-- Task 18
INSERT INTO [Towns]([Name])
	 VALUES ('Sofia')
			,('Plovdiv')
			,('Varna')
			,('Burgas')
		GO

INSERT INTO [Departments]([Name])
	 VALUES ('Engineering')
			,('Sales')			
			,('Marketing')			
			,('Software Development')			
			,('Quality Assurance')
		GO

INSERT INTO [Employees]([FirstName], [MiddleName], [LastName], [JobTitle], [DepartmentId], [HireDate], [Salary])
	 VALUES ('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '02/01/2013', 3500.00)
			,('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '03/02/2004', 4000.00)
			,('Maria', 'Petrova', 'Ivanova',	'Intern', 5, '08/28/2016', 525.25)
			,('Georgi', 'Teziev', 'Ivanov', 'CEO', 2, '12/09/2007', 3000.00)
			,('Peter', 'Pan', 'Pan',	'Intern', 3, '08/28/2016', 599.88)
		GO

SELECT CONCAT([Employees].[FirstName], ' ', [Employees].[MiddleName], ' ', [Employees].[LastName]) AS [Name]
	   ,[Employees].[JobTitle] AS [Job Title]
	   ,[Departments].[Name] AS [Department]
	   ,[Employees].[HireDate] AS [Hire Date]
	   ,[Employees].[Salary] AS [Salary]
  FROM [Employees]
  JOIN [Departments]
    ON [Departments].[Id] = [Employees].[DepartmentId]

-- Task 19
SELECT * 
  FROM [Towns]

SELECT * 
  FROM [Departments] 

SELECT * 
  FROM [Employees]

-- Task 20
  SELECT * 
	FROM [Towns]
ORDER BY [Towns].[Name]

  SELECT * 
    FROM [Departments] 
ORDER BY [Departments].[Name]

  SELECT * 
	FROM [Employees]
ORDER BY [Employees].[Salary] DESC

-- Task 21
  SELECT [Name] 
	FROM [Towns]
ORDER BY [Towns].[Name]

  SELECT [Name] 
    FROM [Departments] 
ORDER BY [Departments].[Name]

  SELECT [FirstName]
		,[LastName]
		,[JobTitle]
		,[Salary]
	FROM [Employees]
ORDER BY [Employees].[Salary] DESC

-- Task 22
UPDATE [Employees]
   SET [Salary] = [Salary] * 1.1

  SELECT [Salary]
	FROM [Employees]
