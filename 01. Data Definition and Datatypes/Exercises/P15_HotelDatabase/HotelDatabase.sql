--Create database Hotel
CREATE DATABASE Hotel

USE Hotel

--Create Table Employees 
CREATE TABLE Employees(
	Id INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(50) NOT NULL,
	LastName NVARCHAR(50) NOT NULL,
	Title NVARCHAR(50),
	Notes NVARCHAR(MAX)
)

--Create Table Customers
CREATE TABLE Customers(
	AccountNumber INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(50) NOT NULL,
	LastName NVARCHAR(50) NOT NULL,
	PhoneNumber NVARCHAR(50),
	EmergencyName NVARCHAR(50),
	EmergencyNumber NVARCHAR(50),
	Notes NVARCHAR(MAX)
)

--Create Table RoomStatus
CREATE TABLE RoomStatus(
	RoomStatus INT PRIMARY KEY IDENTITY,
	Notes NVARCHAR(MAX)	NOT NULL
)

--Create Table RoomTypes
CREATE TABLE RoomTypes(
	RoomType INT PRIMARY KEY IDENTITY,
	Notes NVARCHAR(MAX)	NOT NULL
)

--Create Table BedTypes 
CREATE TABLE BedTypes(
	BedType INT PRIMARY KEY IDENTITY,
	Notes NVARCHAR(MAX)	NOT NULL
)

--Create Table Rooms
CREATE TABLE Rooms(
	RoomNumber INT PRIMARY KEY IDENTITY,
	RoomType INT FOREIGN KEY REFERENCES RoomTypes(RoomType),
	BedType INT FOREIGN KEY REFERENCES BedTypes(BedType),
	Rate DECIMAL(15, 2) NOT NULL,
	RoomStatus INT FOREIGN KEY REFERENCES RoomStatus(RoomStatus),
	Notes NVARCHAR(MAX)	
)

--Create Table Payments
CREATE TABLE Payments(
	Id INT PRIMARY KEY IDENTITY,
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id),
	PaymentDate DATE DEFAULT (GETDATE()),
	AccountNumber INT FOREIGN KEY REFERENCES Customers(AccountNumber),
	FirstDateOccupied DATE NOT NULL,
	LastDateOccupied DATE NOT NULL,
	TotalDays AS DATEDIFF(day, FirstDateOccupied, LastDateOccupied),
	AmountCharged DECIMAL(15, 2),
	TaxRate DECIMAL(15, 2),
	TaxAmount DECIMAL(15, 2),
	PaymentTotal DECIMAL(15, 2),
	Notes NVARCHAR(MAX)	
)

--Create Table Occupancies 
CREATE TABLE Occupancies(
	Id INT PRIMARY KEY IDENTITY,
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id),
	DateOccupied DATE NOT NULL,
	AccountNumber INT FOREIGN KEY REFERENCES Customers(AccountNumber),
	RoomNumber INT FOREIGN KEY REFERENCES Rooms(RoomNumber),
	RateApplied DECIMAL(15, 2) NOT NULL,
	PhoneCharge DECIMAL(15, 2),
	Notes NVARCHAR(MAX)
)

--Insert 3 Employees
INSERT INTO Employees(FirstName, LastName)
VALUES('Ivan', 'Jelezov')

INSERT INTO Employees(FirstName, LastName)
VALUES('Zdravko', 'Zdravkov')

INSERT INTO Employees(FirstName, LastName)
VALUES('Gosho', 'Peshov')

--Insert 3 Customers
INSERT INTO Customers(FirstName, LastName)
VALUES('Asen', 'Ivanov')

INSERT INTO Customers(FirstName, LastName)
VALUES('Alex', 'Kostov')

INSERT INTO Customers(FirstName, LastName)
VALUES('Alen', 'Delon')

--Insert 3 RoomStatus
INSERT INTO RoomStatus(Notes)
VALUES('Occupied')

INSERT INTO RoomStatus(Notes)
VALUES('Available')

INSERT INTO RoomStatus(Notes)
VALUES('Cleaning')

--Insert 3 RoomTypes
INSERT INTO RoomTypes(Notes)
VALUES('Double')

INSERT INTO RoomTypes(Notes)
VALUES('Single')

INSERT INTO RoomTypes(Notes)
VALUES('Appartment')

--Insert 3 BedTypes
INSERT INTO BedTypes(Notes)
VALUES('Double')

INSERT INTO BedTypes(Notes)
VALUES('Single')

INSERT INTO BedTypes(Notes)
VALUES('King size')

--Insert 3 Rooms
INSERT INTO Rooms(RoomType, BedType, Rate, RoomStatus)
VALUES(1, 1, 105.50, 1)

INSERT INTO Rooms(RoomType, BedType, Rate, RoomStatus)
VALUES(2, 2, 85.50, 2)

INSERT INTO Rooms(RoomType, BedType, Rate, RoomStatus)
VALUES(3, 3, 165.50, 3)

--Insert 3 Payments
INSERT INTO Payments(EmployeeId, AccountNumber, FirstDateOccupied, LastDateOccupied)
VALUES(1, 1, '01-01-2018', '01-03-2018')

INSERT INTO Payments(EmployeeId, AccountNumber, FirstDateOccupied, LastDateOccupied)
VALUES(1, 1, '04-04-2018', '04-05-2018')

INSERT INTO Payments(EmployeeId, AccountNumber, FirstDateOccupied, LastDateOccupied)
VALUES(1, 1, '05-05-2018', '06-06-2018')

--Insert 3 Occupancies
INSERT INTO Occupancies(EmployeeId, DateOccupied, AccountNumber, RoomNumber, RateApplied)
VALUES(1, '01-01-2017', 1, 1, 100.05)

INSERT INTO Occupancies(EmployeeId, DateOccupied, AccountNumber, RoomNumber, RateApplied)
VALUES(2, '02-02-2017', 2, 2, 75.85)

INSERT INTO Occupancies(EmployeeId, DateOccupied, AccountNumber, RoomNumber, RateApplied)
VALUES(3, '03-03-2017', 3, 3, 145.65)