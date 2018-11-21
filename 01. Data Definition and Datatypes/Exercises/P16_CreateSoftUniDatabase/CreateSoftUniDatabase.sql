--Create database SoftUni
CREATE DATABASE SoftUni

USE SoftUni

--Create Table Towns 
CREATE TABLE Towns(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(100) NOT NULL,
)

--Create Table Addresses 
CREATE TABLE Addresses(
	Id INT PRIMARY KEY IDENTITY,
	AddressesText NVARCHAR(50) NOT NULL,
	TownId INT FOREIGN KEY REFERENCES Towns(Id),
)

--Create Table Departments  
CREATE TABLE Departments(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(100) NOT NULL,
)

--Create Table Employees  
CREATE TABLE Employees(
	Id INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(50) NOT NULL,
	MiddleName NVARCHAR(50) NOT NULL,
	LastName NVARCHAR(50) NOT NULL,
	JobTitle NVARCHAR(50),
	DepartmentId INT FOREIGN KEY REFERENCES Departments(Id),
	HireDate DATE DEFAULT(GETDATE()),
	Salary DECIMAL(15, 2),
	AddressesId INT FOREIGN KEY REFERENCES Addresses(Id)
)