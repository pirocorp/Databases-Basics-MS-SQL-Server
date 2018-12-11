CREATE DATABASE RentACar
GO

USE RentACar
GO

CREATE TABLE Clients(
	Id INT IDENTITY,
	FirstName NVARCHAR(30) NOT NULL,
	LastName NVARCHAR(30) NOT NULL,
	Gender CHAR(1),
	BirthDate DATETIME,
	CreditCard NVARCHAR(30) NOT NULL,
	CardValidity DATETIME,
	Email NVARCHAR(50) NOT NULL,

	CONSTRAINT PK_Clients_Id
	PRIMARY KEY (Id),

	CONSTRAINT CK_Clients_Gender   
    CHECK (Gender IN ('M', 'F'))
)

CREATE TABLE Towns(
	Id INT IDENTITY,
	[Name] NVARCHAR(50) NOT NULL,

	CONSTRAINT PK_Towns_Id
	PRIMARY KEY (Id),
)

CREATE TABLE Offices(
	Id INT IDENTITY,
	[Name] NVARCHAR(40),
	ParkingPlaces INT,
	TownId INT NOT NULL,

	CONSTRAINT PK_Offices_Id
	PRIMARY KEY (Id),

    CONSTRAINT FK_Offices_TownId_Towns_Id 
    FOREIGN KEY (TownId)     
    REFERENCES Towns(Id)
)

CREATE TABLE Models(
	Id INT IDENTITY,
	Manufacturer NVARCHAR(50) NOT NULL,
	Model NVARCHAR(50) NOT NULL,
	ProductionYear DATETIME,
	Seats INT,
	Class NVARCHAR(10),
	Consumption DECIMAL(14, 2),

	CONSTRAINT PK_Models_Id
	PRIMARY KEY (Id),
)

CREATE TABLE Vehicles(
	Id INT IDENTITY,
	ModelId INT NOT NULL,
	OfficeId INT NOT NULL,
	Mileage INT,

	CONSTRAINT PK_Vehicles_Id
	PRIMARY KEY (Id),

	CONSTRAINT FK_Vehicles_ModelId_Models_Id 
    FOREIGN KEY (ModelId)     
    REFERENCES Models(Id),

	CONSTRAINT FK_Vehicles_OfficeId_Offices_Id 
    FOREIGN KEY (OfficeId)     
    REFERENCES Offices(Id)
)

CREATE TABLE Orders(
	Id INT IDENTITY,
    ClientId INT NOT NULL,
    TownId INT NOT NULL,
    VehicleId INT NOT NULL,
    CollectionDate DATETIME NOT NULL,
    CollectionOfficeId INT NOT NULL,
    ReturnDate DATETIME,
    ReturnOfficeId INT,
    Bill DECIMAL(14, 2),
    TotalMileage INT,

	CONSTRAINT PK_Orders_Id
	PRIMARY KEY (Id),

	CONSTRAINT FK_Orders_ClientId_Clients_Id 
    FOREIGN KEY (ClientId)     
    REFERENCES Clients(Id),

	CONSTRAINT FK_Orders_TownId_Towns_Id 
    FOREIGN KEY (TownId)     
    REFERENCES Towns(Id),

	CONSTRAINT FK_Orders_VehicleId_Vehicles_Id 
    FOREIGN KEY (VehicleId)     
    REFERENCES Vehicles(Id),

	CONSTRAINT FK_Orders_CollectionOfficeId_Offices_Id 
    FOREIGN KEY (CollectionOfficeId)     
    REFERENCES Offices(Id),

	CONSTRAINT FK_Orders_ReturnOfficeId_Offices_Id 
    FOREIGN KEY (ReturnOfficeId)     
    REFERENCES Offices(Id)
)