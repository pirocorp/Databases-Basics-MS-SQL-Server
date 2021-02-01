-- Task 1
CREATE TABLE [Passports](
	[PassportID] INT PRIMARY KEY IDENTITY(101, 1),
	[PassportNumber] NVARCHAR(MAX)
);
GO

CREATE TABLE [Persons](
	[PersonID] INT PRIMARY KEY IDENTITY,
	[FirstName] NVARCHAR(MAX),
	[Salary] DECIMAL(10, 2),
	[PassportID] INT UNIQUE,
	CONSTRAINT [FK_Persons_Passports] FOREIGN KEY ([PassportID]) REFERENCES [Passports] ([PassportID])
);
GO

INSERT INTO [Passports]
	 VALUES ('N34FG21B')
			,('K65LO4R7')
			,('ZE657QP2')
		 GO

INSERT INTO [Persons]
	 VALUES ('Roberto', 43300.00, 102)
			,('Tom', 56100.00, 103)
			,('Yana', 60200.00, 101)
		GO

SELECT * 
  FROM [Passports]

SELECT *
  FROM [Persons]

-- Task 2
CREATE TABLE [Manufacturers](
	[ManufacturerID] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(MAX),
	[EstablishedOn] DATE,
);
GO

CREATE TABLE [Models](
	[ModelID] INT PRIMARY KEY IDENTITY(101, 1),
	[Name] NVARCHAR(MAX),
	[ManufacturerID] INT,
	CONSTRAINT [FK_Models_Manufacturers] FOREIGN KEY ([ManufacturerID]) REFERENCES [Manufacturers]([ManufacturerID])
)
GO

INSERT INTO [Manufacturers]
	 VALUES ('BMW', '03/07/1916')
			,('Tesla', '01/01/2003')
			,('Lada', '05/01/1966')
		 GO

INSERT INTO [Models]
	 VALUES ('X1', 1)
			,('i6', 1)			
			,('Model S', 2)			
			,('Model X', 2)			
			,('Model 3', 2)			
			,('Nova', 3)
		GO

-- Task 3
CREATE TABLE [Students](
	[StudentID] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(MAX),
);
GO

CREATE TABLE [Exams](
	[ExamID] INT PRIMARY KEY IDENTITY(101, 1),
	[Name] NVARCHAR(MAX),
);
GO

CREATE TABLE [StudentsExams](
	[StudentID] INT,
	CONSTRAINT FK_StudentsExams_Students FOREIGN KEY ([StudentID]) REFERENCES [Students]([StudentID]),
	[ExamID] INT,
	CONSTRAINT FK_StudentsExams_Exams FOREIGN KEY ([ExamID]) REFERENCES [Exams]([ExamID]),
	PRIMARY KEY([StudentID], [ExamID])
);
GO

INSERT INTO [Students]
	  VALUES ('Mila')
			 ,('Toni')
			 ,('Ron')
		  GO

INSERT INTO [Exams]
     VALUES ('SpringMVC')
			,('Neo4j')
			,('Oracle 11g')
		GO

INSERT INTO [StudentsExams]
	 VALUES (1, 101)
			,(1, 102)			
			,(2, 101)			
			,(3, 103)			
			,(2, 102)			
			,(2, 103)
		GO

-- Task 4
CREATE TABLE [Teachers](
	[TeacherID] INT PRIMARY KEY IDENTITY(101, 1),
	[Name] NVARCHAR(MAX),
	[ManagerID] INT NULL,
	CONSTRAINT [FK_Teachers_Teachers] FOREIGN KEY([ManagerID]) REFERENCES [Teachers]([TeacherID])
);
GO

INSERT INTO [Teachers] ([Name])
	 VALUES ('John')
			,('Maya')			
			,('Silvia')
			,('Ted')
			,('Mark')
			,('Greta')
		GO

UPDATE [Teachers]
   SET ManagerID = 106
 WHERE TeacherID IN (102, 103)
    GO

UPDATE [Teachers]
   SET ManagerID = 105
 WHERE TeacherID IN (104)
    GO

UPDATE [Teachers]
   SET ManagerID = 101
 WHERE TeacherID IN (105, 106)
    GO

-- Task 5
CREATE TABLE [ItemTypes](
	[ItemTypeID] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(50),
);
GO

CREATE TABLE [Items](
	[ItemID] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(50),
	[ItemTypeID] INT,
	CONSTRAINT [FK_Items_ItemTypes] FOREIGN KEY ([ItemTypeID]) REFERENCES [ItemTypes]([ItemTypeID]),
);
GO

CREATE TABLE [Cities](
	[CityID] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(50),
);
GO

CREATE TABLE [Customers](
	[CustomerID] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(50),
	[Birthday] DATE,
	[CityID] INT,
	CONSTRAINT [FK_Customers_Cities] FOREIGN KEY ([CityID]) REFERENCES [Cities]([CityID]),
);
GO

CREATE TABLE [Orders](
	[OrderID] INT PRIMARY KEY IDENTITY,
	[CustomerID] INT,
	CONSTRAINT [FK_Orders_Customers] FOREIGN KEY ([CustomerID]) REFERENCES [Customers]([CustomerID]),
);
GO

CREATE TABLE [OrderItems](
	[OrderID] INT,
	CONSTRAINT [FK_OrderItems_Orders] FOREIGN KEY ([OrderID]) REFERENCES [Orders]([OrderID]),
	[ItemID] INT,
	CONSTRAINT [FK_OrderItems_Items] FOREIGN KEY ([ItemID]) REFERENCES [Items]([ItemID]),
	PRIMARY KEY (OrderID, ItemID),
);
GO

-- Task 6
CREATE TABLE [Subjects](
	[SubjectID] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(MAX),
);
GO

CREATE TABLE [Majors](
	[MajorID] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(MAX),
);
GO


CREATE TABLE [Students](
	[StudentID] INT PRIMARY KEY IDENTITY,
	[StudentNumber] NVARCHAR(MAX),
	[StudentName] NVARCHAR(MAX),
	[MajorID] INT,
	CONSTRAINT [FK_Students_Majors] FOREIGN KEY([MajorID]) REFERENCES [Majors]([MajorID]),
);
GO

CREATE TABLE [Agenda](
	[StudentID] INT, 
	CONSTRAINT [FK_Agenda_Students] FOREIGN KEY([StudentID]) REFERENCES [Students]([StudentID]),
	[SubjectID] INT,
	CONSTRAINT [FK_Agenda_Subjects] FOREIGN KEY([SubjectID]) REFERENCES [Subjects]([SubjectID]),
	PRIMARY KEY ([StudentID], [SubjectID]),
);
GO

CREATE TABLE [Payments](
	[PaymentID] INT PRIMARY KEY IDENTITY,
	[PaymentDate] DATE,
	[PaymentAmount] DECIMAL(10, 2),
	[StudentID] INT,
	CONSTRAINT [FK_Payments_Students] FOREIGN KEY([StudentID]) REFERENCES [Students]([StudentID]),
);
GO

-- Task 9
USE [Geography]

  SELECT [Mountains].[MountainRange]
		 ,[Peaks].[PeakName]
		 ,[Peaks].[Elevation]
    FROM [Peaks]
    JOIN [Mountains]
	  ON [Peaks].[MountainId] = [Mountains].[Id]
   WHERE [Mountains].[MountainRange] = 'Rila'
ORDER BY [Peaks].[Elevation] DESC