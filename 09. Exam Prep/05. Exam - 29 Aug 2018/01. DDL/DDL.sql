CREATE DATABASE Supermarket
GO

USE Supermarket
GO

CREATE TABLE Categories(
	Id INT IDENTITY,
	[Name] NVARCHAR(30) NOT NULL,

	CONSTRAINT PK_Categories_Id
	PRIMARY KEY (Id),
)

CREATE TABLE Items(
	Id INT IDENTITY,
	[Name] NVARCHAR(30) NOT NULL,
	Price DECIMAL(15,2) NOT NULL,
	CategoryId INT NOT NULL,

	CONSTRAINT PK_Items_Id
	PRIMARY KEY (Id),

	CONSTRAINT FK_Items_CategoryId_Categories_Id
    FOREIGN KEY (CategoryId)     
    REFERENCES Categories(Id)
)

CREATE TABLE Employees(
	Id INT IDENTITY,
	FirstName NVARCHAR(50) NOT NULL,
	LastName NVARCHAR(50) NOT NULL,
	Phone CHAR(12) NOT NULL,
	Salary DECIMAL(15,2) NOT NULL,

	CONSTRAINT PK_Employees_Id
	PRIMARY KEY (Id)
)

CREATE TABLE Orders(
	Id INT IDENTITY,
	[DateTime] DATETIME NOT NULL, 
	EmployeeId INT NOT NULL,

	CONSTRAINT PK_Orders_Id
	PRIMARY KEY (Id),

	CONSTRAINT FK_Orders_EmployeeId_Employees_Id
    FOREIGN KEY (EmployeeId)     
    REFERENCES Employees(Id)
)

CREATE TABLE OrderItems(
	OrderId INT NOT NULL,
	ItemId INT NOT NULL,
	Quantity INT NOT NULL,

	CONSTRAINT PK_OrderItems_OrderId_ItemId
	PRIMARY KEY (OrderId, ItemId),

	CONSTRAINT FK_OrderItems_OrderId_Orders_Id
    FOREIGN KEY (OrderId)     
    REFERENCES Orders(Id),

	CONSTRAINT FK_OrderItems_ItemId_Items_Id
    FOREIGN KEY (ItemId)     
    REFERENCES Items(Id),

	CONSTRAINT CK_OrderItems_Quantity  
    CHECK (Quantity >= 1),
)

CREATE TABLE Shifts(
	Id INT IDENTITY,
	EmployeeId INT,
	CheckIn DATETIME NOT NULL,
	CheckOut DATETIME NOT NULL,

	CONSTRAINT PK_Shifts_Id_EmployeeId
	PRIMARY KEY (Id, EmployeeId),

	CONSTRAINT FK_Shifts_EmployeeId_Employees_Id
    FOREIGN KEY (EmployeeId)     
    REFERENCES Employees(Id),

	CONSTRAINT CK_Shifts_CheckOut  
    CHECK (CheckOut > CheckIn),
)