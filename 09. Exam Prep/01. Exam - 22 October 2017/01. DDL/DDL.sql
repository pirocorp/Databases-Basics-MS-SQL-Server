CREATE DATABASE ReportService
            GO

USE ReportService
 GO

CREATE TABLE Users(
	Id INT IDENTITY,
	Username NVARCHAR(30) NOT NULL,
	[Password] NVARCHAR(50) NOT NULL,
	[Name] NVARCHAR(50),
	Gender CHAR,
	BirthDate DATETIME,
	Age INT,
	Email NVARCHAR(50) NOT NULL,

	CONSTRAINT PK_Users_Id
	PRIMARY KEY (Id),

	CONSTRAINT UQ_Users_Username 
	    UNIQUE(Username),

    CONSTRAINT CK_Users_Gender   
         CHECK (Gender IN ('M', 'F')),
)

CREATE TABLE Departments(
	Id INT IDENTITY,
	[Name] NVARCHAR(50) NOT NULL,

	CONSTRAINT PK_Departments_Id
	PRIMARY KEY (Id),
)

CREATE TABLE Employees(
	Id INT IDENTITY,
	FirstName NVARCHAR(25),
	LastName NVARCHAR(25),
	Gender CHAR,
	BirthDate DATETIME,
	Age INT,
	DepartmentId INT NOT NULL,

	CONSTRAINT PK_Employees_Id
	PRIMARY KEY (Id),

	CONSTRAINT CK_Employees_Gender   
    CHECK (Gender IN ('M', 'F')),

	 CONSTRAINT FK_Employees_DepartmentId_Departments_Id 
    FOREIGN KEY (DepartmentId)     
     REFERENCES Departments(Id)
)

CREATE TABLE Categories(
	Id INT IDENTITY,
	[Name] NVARCHAR(50) NOT NULL,
	DepartmentId INT,

	CONSTRAINT PK_Categories_Id
	PRIMARY KEY (Id),

	 CONSTRAINT FK_Categories_DepartmentId_Departments_Id 
    FOREIGN KEY (DepartmentId)     
     REFERENCES Departments(Id)
)

CREATE TABLE [Status](
	Id INT IDENTITY,
	Label NVARCHAR(30) NOT NULL,

	CONSTRAINT PK_Status_Id
	PRIMARY KEY (Id),
)

CREATE TABLE Reports(
	Id INT IDENTITY,
	CategoryId INT NOT NULL,
	StatusId INT NOT NULL,
	OpenDate DATETIME NOT NULL,
	CloseDate DATETIME,
	[Description] NVARCHAR(200),
	UserId INT NOT NULL,
	EmployeeId INT,

	CONSTRAINT PK_Reports_Id
	PRIMARY KEY (Id),

	 CONSTRAINT FK_Reports_CategoryId_Categories_Id 
    FOREIGN KEY (CategoryId)     
     REFERENCES Categories(Id),

	 CONSTRAINT FK_Reports_StatusId_Status_Id 
    FOREIGN KEY (StatusId)     
     REFERENCES [Status](Id),

	 CONSTRAINT FK_Reports_UserId_Users_Id 
    FOREIGN KEY (UserId)     
     REFERENCES Users(Id),

	 CONSTRAINT FK_Reports_EmployeeId_Employees_Id 
    FOREIGN KEY (EmployeeId)     
     REFERENCES Employees(Id)
)