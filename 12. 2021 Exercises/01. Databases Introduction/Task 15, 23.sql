CREATE DATABASE Hotel
GO

USE Hotel
GO

CREATE TABLE [Employees] (
	[Id] INT PRIMARY KEY IDENTITY,
	[FirstName] NVARCHAR(MAX) NOT NULL,
	[LastName] NVARCHAR(MAX) NOT NULL,
	[Title] NVARCHAR(MAX),
	[Notes] NVARCHAR(MAX),
);
GO

CREATE TABLE [Customers](
	[AccountNumber] INT PRIMARY KEY IDENTITY(1000001, 1),
	[FirstName] NVARCHAR(MAX) NOT NULL,
	[LastName] NVARCHAR(MAX) NOT NULL,
	[PhoneNumber] NVARCHAR(MAX),
	[EmergencyName] NVARCHAR(MAX),
	[EmergencyNumber] NVARCHAR(MAX),
	[Notes] NVARCHAR(MAX),
);
GO

CREATE TABLE [RoomStatus](
	[RoomStatus] NVARCHAR(450) PRIMARY KEY NOT NULL,
	[Notes] NVARCHAR(MAX),
);
GO

CREATE TABLE [RoomTypes](
	[RoomType] NVARCHAR(450) PRIMARY KEY NOT NULL,
	[Notes] NVARCHAR(MAX),
);
GO

CREATE TABLE [BedTypes](
	[BedType] NVARCHAR(450) PRIMARY KEY NOT NULL,
	[Notes] NVARCHAR(MAX),
);
GO

CREATE TABLE [Rooms](
	[RoomNumber] NVARCHAR(450) PRIMARY KEY NOT NULL,
	[RoomType] NVARCHAR(450) NOT NULL,
	CONSTRAINT FK_Rooms_RoomTypes FOREIGN KEY ([RoomType]) REFERENCES [RoomTypes] ([RoomType]),
	[BedType] NVARCHAR(450) NOT NULL,
	CONSTRAINT FK_Rooms_BedTypes FOREIGN KEY ([BedType]) REFERENCES [BedTypes] ([BedType]),
	[Rate] DECIMAL(2) NOT NULL,
	[RoomStatus] NVARCHAR(450) NOT NULL,
	CONSTRAINT FK_Rooms_RoomStatus FOREIGN KEY ([RoomStatus]) REFERENCES [RoomStatus] ([RoomStatus]),
	[Notes] NVARCHAR(MAX),
);
GO

CREATE TABLE [Payments](
	[Id] INT PRIMARY KEY IDENTITY,
	[EmployeeId] INT NOT NULL,
	CONSTRAINT FK_Payments_Employees FOREIGN KEY ([EmployeeId]) REFERENCES [Employees] ([Id]),
	[PaymentDate] DATE,
	[AccountNumber] INT NOT NULL,
	CONSTRAINT FK_Payments_Customers FOREIGN KEY ([AccountNumber]) REFERENCES [Customers] ([AccountNumber]),
	[FirstDateOccupied] DATE,
	[LastDateOccupied] DATE,
	[TotalDays] INT,
	[AmountCharged] DECIMAL(2),
	[TaxRate] DECIMAL(2),
	[TaxAmount] DECIMAL(2),
	[PaymentTotal] DECIMAL(2) NOT NULL,
	[Notes] NVARCHAR(MAX),
);
GO

CREATE TABLE [Occupancies](
	[Id] INT PRIMARY KEY IDENTITY,
	[EmployeeId] INT NOT NULL,
	CONSTRAINT FK_Occupancies_Employees FOREIGN KEY ([EmployeeId]) REFERENCES [Employees] ([Id]),
	[DateOccupied] DATE,
	[AccountNumber] INT NOT NULL,
	CONSTRAINT FK_Occupancies_Customers FOREIGN KEY ([AccountNumber]) REFERENCES [Customers] ([AccountNumber]),
	[RoomNumber] NVARCHAR(450) NOT NULL,
	CONSTRAINT FK_Occupancies_Rooms FOREIGN KEY ([RoomNumber]) REFERENCES [Rooms] ([RoomNumber]),
	[RateApplied] DECIMAL(2),
	[PhoneCharge] DECIMAL(2), -- ?????????
	[Notes] NVARCHAR(MAX),
);
GO

INSERT INTO [Employees] ([FirstName], [LastName])
	 VALUES ('Employee', '1')
			,('Employee', '2')
			,('Employee', '3')
		 GO

INSERT INTO [Customers] ([FirstName], [LastName])
	 VALUES ('Customer', '1')
			,('Customer', '2')
			,('Customer', '3')
		 GO

INSERT INTO [RoomStatus] ([RoomStatus])
	 VALUES ('Free')
			,('Cleaning')
			,('Occupied')
		 GO

INSERT INTO [RoomTypes] ([RoomType])
	 VALUES ('Single')
			,('Double')
			,('Appartment')
		 GO

INSERT INTO [BedTypes] ([BedType])
	 VALUES ('King Size')
			,('Queen Size')
			,('Single')
		 GO

INSERT INTO [Rooms] ([RoomNumber], [Rate], [RoomType], [BedType], [RoomStatus])
	 VALUES ('1A', 15, 'Single', 'Single', 'Free')
			,('2A', 25, 'Double', 'Queen Size', 'Cleaning')
			,('3A', 35, 'Appartment', 'King Size', 'Occupied')
		 GO

INSERT INTO [Payments] ([EmployeeId], [AccountNumber], [PaymentTotal])
	 VALUES (1, 1000001, 25)
			,(2, 1000002, 35)
			,(3, 1000003, 45)
		GO

INSERT INTO [Occupancies] ([EmployeeId], [AccountNumber], [RoomNumber])
	 VALUES (1, 1000001, '1A')
			,(2, 1000002, '2A')
			,(3, 1000003, '3A')
		 GO

-- Task 23
UPDATE [Payments]
   SET [TaxRate] = [TaxRate] * 0.97

SELECT [TaxRate]
  FROM [Payments]

-- Task 24
DELETE FROM [Occupancies]