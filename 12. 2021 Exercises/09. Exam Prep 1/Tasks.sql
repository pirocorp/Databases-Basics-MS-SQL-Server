-- Task 1 DDL
CREATE DATABASE [Airport]
GO

USE [Airport]
GO

CREATE TABLE [Planes](
	[Id] INT PRIMARY KEY IDENTITY
	,[Name] NVARCHAR(30) NOT NULL
	,[Seats] INT NOT NULL
	,[Range] INT NOT NULL
)

CREATE TABLE [Flights] (
	[Id] INT PRIMARY KEY IDENTITY
	,[DepartureTime] DATETIME2 NULL
	,[ArrivalTime] DATETIME2 NULL
	,[Origin] NVARCHAR(50) NOT NULL
	,[Destination] NVARCHAR(50) NOT NULL
	,[PlaneId] INT NOT NULL
	,CONSTRAINT FK_Flights_Planes FOREIGN KEY ([PlaneId]) REFERENCES [Planes] ([Id])
)

CREATE TABLE [Passengers] (
	[Id] INT PRIMARY KEY IDENTITY
	,[FirstName] NVARCHAR(30) NOT NULL
	,[LastName] NVARCHAR(30) NOT NULL
	,[Age] INT NOT NULL
	,[Address] NVARCHAR(30) NOT NULL
	,[PassportId] NCHAR(11) NOT NULL
)

CREATE TABLE [LuggageTypes](
	[Id] INT PRIMARY KEY IDENTITY
	,[Type] NVARCHAR(30) NOT NULL
)

CREATE TABLE [Luggages] (
	[Id] INT PRIMARY KEY IDENTITY
	,[LuggageTypeId] INT NOT NULL
	,CONSTRAINT FK_Luggages_LuggageTypes FOREIGN KEY ([LuggageTypeId]) REFERENCES [LuggageTypes]([Id])
	,[PassengerId] INT NOT NULL
	,CONSTRAINT FK_Luggages_Passengers FOREIGN KEY ([PassengerId]) REFERENCES [Passengers]([Id])
)

CREATE TABLE [Tickets] (
	[Id] INT PRIMARY KEY IDENTITY
	,[PassengerId] INT NOT NULL
	,CONSTRAINT FK_Tickets_Passengers FOREIGN KEY ([PassengerId]) REFERENCES [Passengers]([Id])
	,[FlightId] INT NOT NULL
	,CONSTRAINT FK_Tickets_Flights FOREIGN KEY ([FlightId]) REFERENCES [Flights]([Id])
	,[LuggageId] INT NOT NULL
	,CONSTRAINT FK_Tickets_Luggages FOREIGN KEY ([LuggageId]) REFERENCES [Luggages]([Id])
	,[Price] DECIMAL(14, 2) NOT NULL
)

-- Task 2
INSERT INTO [Planes] ([Name], [Seats], [Range])
VALUES ('Airbus 336', 112, 5132)
,('Airbus 330', 432, 5325)
,('Boeing 369', 231, 2355)
,('Stelt 297', 254, 2143)
,('Boeing 338', 165, 5111)
,('Airbus 558', 387, 1342)
,('Boeing 128', 345, 5541)


INSERT INTO [LuggageTypes]
VALUES('Crossbody Bag')
,('School Backpack')
,('Shoulder Bag')

-- Task 3
 UPDATE Tickets
	SET Price *= 1.13
  WHERE [FlightId] = (SELECT [Id] 
						FROM [Flights]
					   WHERE [Destination] = 'Carlsbad')

-- Task 4
DELETE [Tickets]
 WHERE [FlightId] = (SELECT [Id] FROM [Flights] WHERE [Destination] = 'Ayn Halagim')

DELETE [Flights]
 WHERE [Destination] = 'Ayn Halagim'

-- Task 5
  SELECT * 
    FROM [Planes]
   WHERE [Name] LIKE '%tr%'
ORDER BY [Id]
		,[Name]
		,[Seats]
		,[Range]

-- Task 6
   SELECT [F].[Id] AS [FlightId]
		 ,SUM([T].[Price]) AS [Price]
     FROM [Flights] AS [F]
     JOIN [Tickets] AS [T]
       ON [F].[Id] = [T].[FlightId]
 GROUP BY [F].[Id]
 ORDER BY [Price] DESC
		 ,[FlightId] ASC

-- Task 7
  SELECT CONCAT([P].[FirstName], ' ', [P].[LastName]) AS [Full Name]
  	    ,[F].[Origin] AS [Origin]
  	    ,[F].[Destination] AS [Destination]
    FROM [Passengers] AS [P]
    JOIN [Tickets] AS [T]
      ON [P].[Id] = [T].[PassengerId]
    JOIN [Flights] AS [F]
      ON [T].[FlightId] = [F].[Id]
ORDER BY [Full Name]
		,[Origin]
		,[Destination]

-- Task 8
   SELECT [FirstName] AS [First Name]
		 ,[LastName] AS [Last Name]
		 ,[Age]
     FROM [Passengers] AS [P]
LEFT JOIN [Tickets] AS [T]
       ON [P].[Id] = [T].[PassengerId]
	WHERE [T].[Id] IS NULL
 ORDER BY [Age] DESC
		 ,[First Name] ASC
		 ,[Last Name] ASC

-- Task 9
  SELECT CONCAT([P].[FirstName], ' ', [P].[LastName]) AS [Full Name]
  	    ,[A].[Name] AS [Plane Name]
  	    ,CONCAT([F].[Origin], ' - ', [F].[Destination]) AS [Trip]
  	    ,[LT].[Type] AS [Luggage Type] 
    FROM [Passengers] AS [P]
    JOIN [Tickets] AS [T]
      ON [P].[Id] = [T].[PassengerId]
    JOIN [Flights] AS [F]
      ON [T].[FlightId] = [F].[Id]
    JOIN [Planes] AS [A]
      ON [F].[PlaneId] = [A].[Id]
    JOIN [Luggages] AS [L]
      ON [T].[LuggageId] = [L].[Id]
    JOIN [LuggageTypes] AS [LT]
      ON [L].[LuggageTypeId] = [LT].[Id]
ORDER BY [Full Name]
		,[Plane Name]
		,[F].[Origin]
		,[F].[Destination]
		,[Luggage Type]

-- Task 10
   SELECT [P].[Name] AS [Plane Name]
		 ,[P].[Seats] AS [Seats]
		 ,COUNT([T].[PassengerId]) AS [Passengers Count]
     FROM [Planes] AS [P] 
LEFT JOIN [Flights] AS [F]
       ON [P].[Id] = [F].[PlaneId]
LEFT JOIN [Tickets] AS [T]
	   ON [F].[Id] = [T].[FlightId]
 GROUP BY [P].[Name] 
		 ,[P].[Seats]
 ORDER BY [Passengers Count] DESC
		 ,[Plane Name] ASC
		 ,[Seats] ASC
GO

-- Task 11
CREATE FUNCTION udf_CalculateTickets(@origin NVARCHAR(50), @destination NVARCHAR(50), @peopleCount INT)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	IF @peopleCount <= 0
		RETURN 'Invalid people count!'

	DECLARE @flightId INT
	SET @flightId = (SELECT Id 
					  FROM Flights
					 WHERE Origin = @origin
					   AND Destination = @destination)

	IF @flightId IS NULL
		RETURN 'Invalid flight!'

	DECLARE @ticketPrice DECIMAL(14, 2)
	SET @ticketPrice = (SELECT Price FROM Tickets WHERE FlightId = @flightId)

	IF @ticketPrice IS NULL
		RETURN 'Invalid flight!'

	RETURN CONCAT('Total price ', @ticketPrice * @peopleCount);
END
GO

-- Task 12
CREATE PROCEDURE [usp_CancelFlights]
AS
	UPDATE [Flights]
	   SET [ArrivalTime] = NULL
		  ,[DepartureTime] = NULL
	 WHERE [ArrivalTime] < [DepartureTime]
GO

EXEC usp_CancelFlights