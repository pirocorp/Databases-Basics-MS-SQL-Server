--Create database Movies
CREATE DATABASE Movies

--Create Table Directors
CREATE TABLE Directors(
	Id INT PRIMARY KEY IDENTITY,
	DirectorName NVARCHAR(100) NOT NULL,
	Notes NVARCHAR(MAX)
)

--Create Table Genres
CREATE TABLE Genres(
	Id INT PRIMARY KEY IDENTITY,
	GenreName NVARCHAR(50) NOT NULL,
	Notes NVARCHAR(MAX)
)

--Create Table Categories
CREATE TABLE Categories(
	Id INT PRIMARY KEY IDENTITY,
	CategoryName NVARCHAR(50) NOT NULL,
	Notes NVARCHAR(MAX)
)

--Create Table Movies
CREATE TABLE Movies(
	Id INT PRIMARY KEY IDENTITY,
	Title NVARCHAR(50) NOT NULL,
	DirectorId INT FOREIGN KEY REFERENCES Directors(Id),
	CopyrightYear INT,
	[Length] DECIMAL(10, 2),
	GenreId INT FOREIGN KEY REFERENCES Genres(Id),
	CategoryId INT FOREIGN KEY REFERENCES Categories(Id),
	Rating NVARCHAR(50),
	Notes NVARCHAR(MAX)
)

--Insert 5 Directors
INSERT INTO Directors(DirectorName)
VALUES('George Lucas')

INSERT INTO Directors(DirectorName)
VALUES('James Cameron')

INSERT INTO Directors(DirectorName)
VALUES('Stanley Kubrick')

INSERT INTO Directors(DirectorName)
VALUES('Ridley Scott')

INSERT INTO Directors(DirectorName)
VALUES('Steven Spielberg')

--Insert 5 Genres
INSERT INTO Genres(GenreName)
VALUES('Sci-fi')

INSERT INTO Genres(GenreName)
VALUES('Horror')

INSERT INTO Genres(GenreName)
VALUES('Action')

INSERT INTO Genres(GenreName)
VALUES('Comedy')

INSERT INTO Genres(GenreName)
VALUES('Thriller')

--Insert 5 Categories
INSERT INTO Categories(CategoryName)
VALUES('Short')

INSERT INTO Categories(CategoryName)
VALUES('TV')

INSERT INTO Categories(CategoryName)
VALUES('Feature film')

INSERT INTO Categories(CategoryName)
VALUES('Animation')

INSERT INTO Categories(CategoryName)
VALUES('Blockbuster')

--Insert 5 Movies
INSERT INTO Movies(Title, DirectorId, CopyrightYear, GenreId, CategoryId)
VALUES('Blade Runner', 4, 1982, 1, 3)

INSERT INTO Movies(Title, DirectorId, CopyrightYear, GenreId, CategoryId)
VALUES('Star Wars', 1, 1977, 1, 3)

INSERT INTO Movies(Title, DirectorId, CopyrightYear, GenreId, CategoryId)
VALUES('Alien', 4, 1979, 1, 3)

INSERT INTO Movies(Title, DirectorId, CopyrightYear, GenreId, CategoryId)
VALUES('2001: A Space Odyssey', 3, 1968, 1, 3)

INSERT INTO Movies(Title, DirectorId, CopyrightYear, GenreId, CategoryId)
VALUES('A.I. Artificial Intelligence', 5, 2001, 1, 3)