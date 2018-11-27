CREATE TABLE Passports(
	PassportID INT,
	PassportNumber NVARCHAR(64),

	CONSTRAINT PK_Passports
	PRIMARY KEY(PassportID),
)

CREATE TABLE Persons(
	PersonID INT IDENTITY,
	FirstName NVARCHAR(64),
	Salary DECIMAL(10, 2),
	PassportID INT,

	CONSTRAINT PK_Persons
	PRIMARY KEY(PersonID),

	CONSTRAINT FK_Persons_Passports
	FOREIGN KEY(PassportID)
	REFERENCES Passports(PassportID),

	CONSTRAINT UQ_Persons_PassportID
	UNIQUE(PassportID)
)

INSERT INTO Passports
VALUES (101, 'N34FG21B'),
       (102, 'K65LO4R7'),
	   (103, 'ZE657QP2')


INSERT INTO Persons
VALUES ('Roberto', 43300.00, 102),
       ('Tom', 56100.00, 103),
	   ('Yana', 60200.00, 101)

SELECT * 
  FROM Persons

SELECT *
  FROM Passports