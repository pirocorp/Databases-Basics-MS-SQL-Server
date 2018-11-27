USE SoftUni
 GO

DROP DATABASE IF EXISTS Demos
  GO

CREATE DATABASE Demos
	GO

USE Demos
 GO

 DROP TABLE IF EXISTS Peaksc
 DROP TABLE IF EXISTS Mountains
   GO

--The table holding the referenced primary key is the parent/referenced table
CREATE TABLE Mountains(
	MountainID INT IDENTITY,
	[Name] NVARCHAR(64) NOT NULL,

	CONSTRAINT PK_Mountains
	PRIMARY KEY(MountainID)
)

--The table holding the foreign key is the child table
--Many-to-One: Foreign Key
CREATE TABLE Peaks(
	PeakID INT IDENTITY,
	[Name] NVARCHAR(64) NOT NULL,
	MountainID INT NOT NULL,

	CONSTRAINT PK_Peaks
	PRIMARY KEY(PeakID),

	CONSTRAINT FK_Peaks_Mountains
	FOREIGN KEY(MountainID)
	REFERENCES Mountains(MountainID)
)

SELECT * 
  FROM Mountains

SELECT *
  FROM Peaks
    GO

 DROP TABLE IF EXISTS EmployeesProjects
 DROP TABLE IF EXISTS Employees
 DROP TABLE IF EXISTS Projects
   GO

--Many-to-Many: Tables
CREATE TABLE Employees(
	EmployeeID INT IDENTITY,
	[Name] NVARCHAR(64) NOT NULL,

	CONSTRAINT PK_Employees
	PRIMARY KEY(EmployeeID)
)

CREATE TABLE Projects(
	ProjectID INT IDENTITY,
	[Name] NVARCHAR(64) NOT NULL,

	CONSTRAINT PK_Projects
	PRIMARY KEY(ProjectID)
)

--Many-to-Many: Mapping Table
CREATE TABLE EmployeesProjects(
	EmployeeID INT,
	ProjectID INT,

	CONSTRAINT PK_EmployeesProjects
	PRIMARY KEY(EmployeeID, ProjectID),

	CONSTRAINT FK_EmployeesProjects_EmployeeID
	FOREIGN KEY(EmployeeID)
	REFERENCES Employees(EmployeeID),

	CONSTRAINT FK_EmployeesProjects_ProjectID
	FOREIGN KEY(ProjectID)
	REFERENCES Projects(ProjectID),
)

SELECT * 
  FROM Employees

SELECT * 
  FROM Projects

SELECT *
  FROM EmployeesProjects

SELECT * 
  FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    GO


 DROP TABLE IF EXISTS Cars
 DROP TABLE IF EXISTS Drivers
   GO

--One-to-One
CREATE TABLE Drivers(
	DriverID INT IDENTITY,
	[Name] NVARCHAR(64) NOT NULL,

	CONSTRAINT PK_Drivers
	PRIMARY KEY(DriverID)
)

CREATE TABLE Cars(
	CarID INT IDENTITY,
	DriverID INT,

	CONSTRAINT PK_Cars
	PRIMARY KEY(CarID),

	CONSTRAINT FK_Cars_Drivers 
	FOREIGN KEY(DriverID) 
	REFERENCES Drivers(DriverID),

	CONSTRAINT UC_Cars
	UNIQUE(DriverID)
)

SELECT * 
  FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
 WHERE TABLE_NAME IN ('Drivers', 'Cars')
    GO

--JOIN Statements
--With a JOIN statement, we can get data from two tables simultaneously
--JOINs require at least two tables and a "join condition"
USE [Geography]
 GO

  SELECT MountainRange, 
         PeakName, 
  	     Elevation
    FROM Peaks
    JOIN Mountains ON Peaks.MountainId = Mountains.Id
   WHERE MountainId = (
                       SELECT Id 
                         FROM Mountains
                        WHERE MountainRange = 'Rila'
					   )
ORDER BY Elevation DESC
      GO

