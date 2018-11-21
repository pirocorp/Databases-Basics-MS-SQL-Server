--Create database Movies
CREATE DATABASE CarRental

USE CarRental

--Create Table Categories
CREATE TABLE Categories(
	Id INT PRIMARY KEY IDENTITY,
	CategoryName NVARCHAR(50) NOT NULL,
	DailyRate DECIMAL(15, 2) NOT NULL,
	WeeklyRate DECIMAL(15, 2) NOT NULL,
	MontlyRate DECIMAL(15, 2) NOT NULL,
	WeekendRate DECIMAL(15, 2) NOT NULL,
)

--Create Table Cars
CREATE TABLE Cars(
	Id INT PRIMARY KEY IDENTITY,
	PlateNumber NVARCHAR(50) NOT NULL UNIQUE,
	Manufacturer NVARCHAR(50) NOT NULL,
	Model NVARCHAR(50) NOT NULL,
	CarYear INT NOT NULL,
	CategoryId INT FOREIGN KEY REFERENCES Categories(Id) NOT NULL,
	Doors INT NOT NULL CHECK(Doors >= 2),
	Picture VARBINARY(MAX), 
	Condition NVARCHAR(MAX),
	Available BIT DEFAULT(1)
)

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
	Id INT PRIMARY KEY IDENTITY,
	DriverLicenceNumber NVARCHAR(50) NOT NULL,
	FullName NVARCHAR(100) NOT NULL,
	[Address] NVARCHAR(100) NOT NULL,
	City NVARCHAR(100) NOT NULL,
	ZIPCode NVARCHAR(100) NOT NULL,
	Notes NVARCHAR(MAX)
)

--Create Table RentalOrders
CREATE TABLE RentalOrders(
	Id INT PRIMARY KEY IDENTITY,
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id) NOT NULL,
	CustomerId INT FOREIGN KEY REFERENCES Customers(Id) NOT NULL,
	CarId INT FOREIGN KEY REFERENCES Cars(Id) NOT NULL,
	TankLevel INT NOT NULL,
	KilometrageStart INT NOT NULL,
	KilometrageEnd INT NOT NULL,
	TotalKilometrage AS KilometrageEnd - KilometrageStart,
	StartDate DATETIME NOT NULL,
	EndDate DATETIME NOT NULL,
	TotalDays AS DATEDIFF(day, StartDate, EndDate),
	RateApplied DECIMAL(15, 2) NOT NULL,
	TaxRate DECIMAL(15, 2) NOT NULL,
	OrderStatus NVARCHAR(20) NOT NULL CHECK (OrderStatus IN('Returned', 'Pending', 'Not Returned')),
	Notes NVARCHAR(MAX)
) 

--Insert 3 Categories
INSERT INTO Categories(CategoryName, DailyRate, WeeklyRate, MontlyRate, WeekendRate)
VALUES('SUV', 50, 300, 1200, 120)

INSERT INTO Categories(CategoryName, DailyRate, WeeklyRate, MontlyRate, WeekendRate)
VALUES('Luxury', 100, 600, 2400, 240)

INSERT INTO Categories(CategoryName, DailyRate, WeeklyRate, MontlyRate, WeekendRate)
VALUES('Sedan', 25, 150, 600, 60)

--Insert 3 Cars
INSERT INTO Cars(PlateNumber, Manufacturer, Model, CarYear, CategoryId, Doors)
VALUES('H1178AX', 'AUDI', 'A4', 2015, 3, 4)

INSERT INTO Cars(PlateNumber, Manufacturer, Model, CarYear, CategoryId, Doors)
VALUES('B1178465BB', 'MERCEDES', 'AMG S63', 2018, 2, 4)

INSERT INTO Cars(PlateNumber, Manufacturer, Model, CarYear, CategoryId, Doors)
VALUES('CA455131TA', 'BMW', 'X5', 2016, 1, 5)

--Insert 3 Employees
INSERT INTO Employees(FirstName, LastName)
VALUES('Velizar', 'Dimitrov')

INSERT INTO Employees(FirstName, LastName)
VALUES('Slavi', 'Trifonov')

INSERT INTO Employees(FirstName, LastName)
VALUES('Petar', 'Bluskov')

--Insert 3 Customers
INSERT INTO Customers(DriverLicenceNumber, FullName, [Address], City, ZIPCode)
VALUES('6464654646', 'Petar Pavlov', 'Slavqnski 6', 'Varna', '9600')

INSERT INTO Customers(DriverLicenceNumber, FullName, [Address], City, ZIPCode)
VALUES('123654789', 'Iliq Kostov', 'Marica 3', 'Sofia', '1000')

INSERT INTO Customers(DriverLicenceNumber, FullName, [Address], City, ZIPCode)
VALUES('999999999', 'Zdravko Zdravkov', 'Firmin Lecharlier 170', 'Brussels', '1090')

--Insert 3 RentalOrders
INSERT INTO RentalOrders(EmployeeId, CustomerId, CarId, TankLevel, 
KilometrageStart, KilometrageEnd, StartDate, EndDate, RateApplied, 
TaxRate, OrderStatus)
VALUES(1, 1, 1, 100, 150, 350, '01-02-2018', '10-03-2018', 50, 10, 'Returned')

INSERT INTO RentalOrders(EmployeeId, CustomerId, CarId, TankLevel, 
KilometrageStart, KilometrageEnd, StartDate, EndDate, RateApplied, 
TaxRate, OrderStatus)
VALUES(2, 2, 2, 50, 1000, 1500, '02-22-2018', '03-02-2018', 100, 10, 'Pending')

INSERT INTO RentalOrders(EmployeeId, CustomerId, CarId, TankLevel, 
KilometrageStart, KilometrageEnd, StartDate, EndDate, RateApplied, 
TaxRate, OrderStatus)
VALUES(3, 3, 3, 110, 2000, 3000, '01-30-2018', '03-30-2018', 25, 10, 'Not Returned')