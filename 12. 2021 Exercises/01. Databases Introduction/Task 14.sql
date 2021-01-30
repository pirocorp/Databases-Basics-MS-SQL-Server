CREATE DATABASE [CarRental]
GO

USE [CarRental]
GO

CREATE TABLE [Categories](
	[Id] INT PRIMARY KEY IDENTITY,
	[CategoryName] NVARCHAR(MAX) NOT NULL,
	[DailyRate] DECIMAL(2) NOT NULL,
	[WeeklyRate] DECIMAL(2) NOT NULL,
	[MonthlyRate] DECIMAL(2) NOT NULL,
	[WeekendRate] DECIMAL(2) NOT NULL,
);
GO

CREATE TABLE [Cars](
	[Id] INT PRIMARY KEY IDENTITY,
	[PlateNumber] NVARCHAR(MAX) NOT NULL,
	[Manufacturer] NVARCHAR(MAX) NOT NULL,
	[Model] NVARCHAR(MAX) NOT NULL,
	[CarYear] INT NOT NULL,
	[CategoryId] INT NOT NULL,
	CONSTRAINT FK_Cars_Categories FOREIGN KEY ([CategoryId]) REFERENCES [Categories] ([Id]),
	[Doors] INT,
	[Picture] VARBINARY(MAX),
	[Condition] NVARCHAR(MAX),
	[Available] BIT NOT NULL
);
GO

CREATE TABLE [Employees](
	[Id] INT PRIMARY KEY IDENTITY,
	[FirstName] NVARCHAR(MAX) NOT NULL,
	[LastName] NVARCHAR(MAX) NOT NULL,
	[Title] NVARCHAR(MAX),
	[Notes] NVARCHAR(MAX),
)
GO

CREATE TABLE [Customers](
	[Id] INT PRIMARY KEY IDENTITY,
	[DriverLicenceNumber] NVARCHAR(MAX) NOT NULL,
	[FullName] NVARCHAR(MAX) NOT NULL,
	[Address] NVARCHAR(MAX),
	[City] NVARCHAR(MAX),
	[ZIPCode] NVARCHAR(MAX),
	[Notes] NVARCHAR(MAX),
)
GO

CREATE TABLE [RentalOrders](
	[Id] INT PRIMARY KEY IDENTITY,
	[EmployeeId] INT NOT NULL,
	CONSTRAINT FK_RentalOrders_Employees FOREIGN KEY ([EmployeeId]) REFERENCES [Employees] ([Id]),
	[CustomerId] INT NOT NULL,
	CONSTRAINT FK_RentalOrders_Customers FOREIGN KEY ([CustomerId]) REFERENCES [Customers] ([Id]),
	[CarId] INT NOT NULL,
	CONSTRAINT FK_RentalOrders_Cars FOREIGN KEY ([CarId]) REFERENCES [Cars] ([Id]),
	[TankLevel] DECIMAL(2),
	[KilometrageStart] DECIMAL(2),
	[KilometrageEnd] DECIMAL(2),
	[TotalKilometrage] DECIMAL(2),
	[StartDate] DATE,
	[EndDate] DATE,
	[TotalDays] INT,
	[RateApplied] DECIMAL(2),
	[TaxRate] DECIMAL(2),
	[OrderStatus] BIT,
	[Notes] NVARCHAR(MAX),
)
GO

INSERT INTO [Categories] ([CategoryName], [DailyRate], [WeeklyRate], [MonthlyRate], [WeekendRate])
     VALUES ('1', 1.1, 2.2, 3.3, 4.4)
			,('2', 2.1, 3.2, 4.3, 5.4)
			,('3', 3.1, 4.2, 5.3, 6.4)
		GO

INSERT INTO [Cars] ([PlateNumber], [Manufacturer], [Model], [CarYear], [CategoryId], [Available])
	 VALUES ('Vanko 1', 'BMW', 'Z3', 2015, 1, 1)
			,('Vanko 2', 'BMW', 'X5', 2016, 2, 1)
			,('Vanko 3', 'BMW', '7', 2018, 3, 1)
		GO

INSERT INTO [Employees] ([FirstName], [LastName])
	 VALUES ('Mi6o', '1')
			,('Pi6o', '2')
			,('Ti6o', '3')
		GO

INSERT INTO [Customers] ([DriverLicenceNumber], [FullName])
	 VALUES ('10203040', 'Gosho 1')
			,('4565464', 'Gosho 2')
			,('3213132', 'Gosho 3')
		 GO

INSERT INTO [RentalOrders]([EmployeeId], [CustomerId], [CarId]) 
	 VALUES (1, 1, 1)
			,(2, 2, 2)
			,(3, 3, 3)
		GO