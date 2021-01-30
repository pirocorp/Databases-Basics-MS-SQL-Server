-- Task 13
CREATE DATABASE [Movies]
			GO

USE [Movies]
 GO

CREATE TABLE [Directors] (
	[Id] INT PRIMARY KEY IDENTITY,
	[DirectorName] NVARCHAR(MAX) NOT NULL,
	[Notes] NVARCHAR(MAX)
);
GO

CREATE TABLE [Genres](
	[Id] INT PRIMARY KEY IDENTITY,
	[GenreName] NVARCHAR(MAX) NOT NULL,
	[Notes] NVARCHAR(MAX)
);
GO

CREATE TABLE [Categories](
	[Id] INT PRIMARY KEY IDENTITY,
	[CategoryName] NVARCHAR(MAX) NOT NULL,
	[Notes] NVARCHAR(MAX)
);
GO

CREATE TABLE [Movies](
	[Id] INT PRIMARY KEY IDENTITY,
	[Title] NVARCHAR(MAX) NOT NULL,
	[DirectorId] INT NOT NULL,
	CONSTRAINT FK_Movies_Directors FOREIGN KEY ([DirectorId]) REFERENCES [Directors] ([Id]),
	[CopyrightYear] INT NOT NULL, 
	[Length] TIME NOT NULL,
	[GenreId] INT NOT NULL,
	CONSTRAINT FK_Movies_Genres FOREIGN KEY ([GenreId]) REFERENCES [Genres] ([Id]),
	[CategoryId] INT NOT NULL,
	CONSTRAINT FK_Movies_Categories FOREIGN KEY ([CategoryId]) REFERENCES [Categories] ([Id]),
	[Rating] DECIMAL(2),
	[Notes] NVARCHAR(MAX)
);
GO

INSERT INTO [Directors] ([DirectorName])
	 VALUES ('Director 1')
			,('Director 2')
			,('Director 3')
			,('Director 4')
			,('Director 5')
		 GO

INSERT INTO [Genres] ([GenreName])
	 VALUES ('Genre 1')
			,('Genre 2')
			,('Genre 3')
			,('Genre 4')
			,('Genre 5')
		 GO

INSERT INTO [Categories] ([CategoryName])
	 VALUES ('Category 1')
			,('Category 2')
			,('Category 3')
			,('Category 4')
			,('Category 5')
		 GO

INSERT INTO [Movies] ([Title], [CopyrightYear], [Length], [DirectorId], [GenreId], [CategoryId])
	 VALUES ('Title 1', 2000, '01:35:24', 1, 1, 1)
		    ,('Title 2', 2001, '02:35:24', 2, 2, 2)
			,('Title 3', 2002, '03:35:24', 3, 3, 3)
			,('Title 4', 2003, '04:35:24', 4, 4, 4)
			,('Title 5', 2004, '05:35:24', 5, 5, 5)
		GO