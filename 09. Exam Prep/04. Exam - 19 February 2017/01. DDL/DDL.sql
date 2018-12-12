CREATE DATABASE Bakery
GO

USE Bakery
GO

CREATE TABLE Countries(
	Id INT IDENTITY,
	[Name] NVARCHAR(50),

	CONSTRAINT PK_Countries_Id
	PRIMARY KEY (Id),

	CONSTRAINT UQ_Countries_Name
	UNIQUE([Name])
)

CREATE TABLE Products(
	Id INT IDENTITY,
    [Name] NVARCHAR(25),
    [Description] NVARCHAR(250),
    Recipe NVARCHAR(MAX),
    Price MONEY,

	CONSTRAINT PK_Products_Id
	PRIMARY KEY (Id),

	CONSTRAINT UQ_Products_Name
	UNIQUE([Name]),

	CONSTRAINT CK_Products_Price
	CHECK(Price >= 0)
)

CREATE TABLE Customers(
	Id INT IDENTITY,
    FirstName NVARCHAR(25),
    LastName NVARCHAR(25),
    Gender CHAR,
    Age INT,
    PhoneNumber CHAR(10),
    CountryId INT,

	CONSTRAINT PK_Customers_Id
	PRIMARY KEY (Id),

	CONSTRAINT CK_Customers_Gender   
    CHECK (Gender IN ('M', 'F')),

	CONSTRAINT FK_Customers_CountryId_Countries_Id
	FOREIGN KEY (CountryId)
	REFERENCES Countries(Id)
)

CREATE TABLE Feedbacks(
	Id INT IDENTITY,
    [Description] NVARCHAR(255),
    Rate DECIMAL(10, 2),
    ProductId INT,
    CustomerId INT,

	CONSTRAINT PK_Feedbacks_Id
	PRIMARY KEY (Id),

	CONSTRAINT CK_Feedbacks_Rate
	CHECK (Rate BETWEEN 0 AND 10),

	CONSTRAINT FK_Feedbacks_ProductId_Products_Id
	FOREIGN KEY (ProductId)
	REFERENCES Products(Id),

	CONSTRAINT FK_Feedbacks_CustomerId_Customers_Id
	FOREIGN KEY (CustomerId)
	REFERENCES Customers(Id)
)

CREATE TABLE Distributors(
	Id INT IDENTITY,
    [Name] NVARCHAR(25),
    AddressText NVARCHAR(30),
    Summary NVARCHAR(200),
    CountryId INT,

	CONSTRAINT PK_Distributors_Id
	PRIMARY KEY (Id),

	CONSTRAINT UQ_Distributors_Name
	UNIQUE([Name]),

	CONSTRAINT FK_Distributors_CountryId_Countries_Id
	FOREIGN KEY (CountryId)
	REFERENCES Countries(Id)
)

CREATE TABLE Ingredients(
	Id INT IDENTITY,
    [Name] NVARCHAR(30),
    [Description] NVARCHAR(200),
    OriginCountryId INT,
    DistributorId INT,

	CONSTRAINT PK_Ingredients_Id
	PRIMARY KEY (Id),

	CONSTRAINT FK_Ingredients_OriginCountryId_Countries_Id
	FOREIGN KEY (OriginCountryId)
	REFERENCES Countries(Id),

	CONSTRAINT FK_Ingredients_DistributorId_Distributors_Id
	FOREIGN KEY (DistributorId)
	REFERENCES Distributors(Id)
)

CREATE TABLE ProductsIngredients(
	ProductId INT NOT NULL,
    IngredientId INT NOT NULL,

	CONSTRAINT PK_ProductsIngredients_ProductId_IngredientId
	PRIMARY KEY (ProductId, IngredientId),

	CONSTRAINT FK_ProductsIngredients_ProductId_Products_Id
    FOREIGN KEY (ProductId)     
    REFERENCES Products(Id),

	CONSTRAINT FK_ProductsIngredients_IngredientId_Ingredients_Id
    FOREIGN KEY (IngredientId)     
    REFERENCES Ingredients(Id),
)