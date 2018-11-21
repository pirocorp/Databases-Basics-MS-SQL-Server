CREATE TABLE People(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(200) NOT NULL,
	Picture BINARY(2048),
	Height DECIMAL(15, 2),
	[Weight] DECIMAL(15, 2),
	Gender CHAR(1) NOT NULL CHECK(Gender IN ('m', 'f')),
	Birthdate DATE NOT NULL,
	Biography NVARCHAR(MAX)
)

INSERT INTO People([Name], Gender, Birthdate)
VALUES('Pesho', 'm', '04-09-1983')

INSERT INTO People([Name], Gender, Birthdate)
VALUES('Gosho', 'm', '09-15-1989')

INSERT INTO People([Name], Gender, Birthdate)
VALUES('Iliana', 'f', '03-30-1990')

INSERT INTO People([Name], Gender, Birthdate)
VALUES('Maria', 'f', '12-07-1993')

INSERT INTO People([Name], Gender, Birthdate)
VALUES('Ilian', 'm', '09-04-2010')