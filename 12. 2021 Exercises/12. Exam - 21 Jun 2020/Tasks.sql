-- Task 1
CREATE DATABASE [Trips] 
GO

USE [Trips]
GO

CREATE TABLE [Cities] (
	[Id] INT PRIMARY KEY IDENTITY
	,[Name] NVARCHAR(20) NOT NULL
	,[CountryCode] CHAR(2) NOT NULL
)

CREATE TABLE [Hotels](
	[Id] INT PRIMARY KEY IDENTITY
	,[Name] NVARCHAR(30) NOT NULL
	,[CityId] INT NOT NULL REFERENCES [Cities]([Id])
	,[EmployeeCount] INT NOT NULL
	,[BaseRate] DECIMAL(18, 2)
)

CREATE TABLE [Rooms](
	[Id] INT PRIMARY KEY IDENTITY
	,[Price] DECIMAL(18, 2) NOT NULL
	,[Type] NVARCHAR(20) NOT NULL
	,[Beds] INT NOT NULL
	,[HotelId] INT NOT NULL REFERENCES [Hotels]([Id])
)

CREATE TABLE [Trips] (
	[Id] INT PRIMARY KEY IDENTITY
	,[RoomId] INT NOT NULL REFERENCES [Rooms]([Id])
	,[BookDate] DATE NOT NULL 
	,CHECK([BookDate] < [ArrivalDate])
	,[ArrivalDate] DATE NOT NULL 
	,CHECK([ArrivalDate] < [ReturnDate])
	,[ReturnDate] DATE NOT NULL
	,[CancelDate] DATE 
)

CREATE TABLE [Accounts] (
	[Id] INT PRIMARY KEY IDENTITY
	,[FirstName] NVARCHAR(50) NOT NULL
	,[MiddleName] NVARCHAR(20)
	,[LastName] NVARCHAR(50) NOT NULL
	,[CityId] INT NOT NULL REFERENCES [Cities]([Id])
	,[BirthDate] DATE NOT NULL
	,[Email] VARCHAR(100) UNIQUE
)

CREATE TABLE [AccountsTrips] (
	[AccountId] INT NOT NULL REFERENCES [Accounts]([Id])
	,[TripId] INT NOT NULL REFERENCES [Trips]([Id])
	,CONSTRAINT PK_AccountsTrips_AccountId_TripId PRIMARY KEY ([AccountId], [TripId])
	,[Luggage] INT NOT NULL CHECK([Luggage] >= 0)
)

-- Task 2
INSERT INTO [Accounts]
VALUES ('John', 'Smith', 'Smith', 34, '1975-07-21', 'j_smith@gmail.com')
,('Gosho', NULL, 'Petrov', 11, '1978-05-16', 'g_petrov@gmail.com')
,('Ivan', 'Petrovich', 'Pavlov', 59, '1849-09-26', 'i_pavlov@softuni.bg')
,('Friedrich', 'Wilhelm', 'Nietzsche', 2, '1844-10-15', 'f_nietzsche@softuni.bg')

INSERT INTO [Trips]
VALUES (101, '2015-04-12', '2015-04-14', '2015-04-20', '2015-02-02')
,(102, '2015-07-07', '2015-07-15', '2015-07-22', '2015-04-29')
,(103, '2013-07-17', '2013-07-23', '2013-07-24', NULL)
,(104, '2012-03-17', '2012-03-31', '2012-04-01', '2012-01-10')
,(109, '2017-08-07', '2017-08-28', '2017-08-29', NULL)

-- Task 3
UPDATE [Rooms]
   SET [Price] *= 1.14
 WHERE [HotelId] IN (5, 7, 9)
 
 
-- Task 4
DELETE [AccountsTrips]
 WHERE [AccountId] = 47

-- Task 5
  SELECT 
  	     [FirstName]
  	    ,[LastName]
  	    ,FORMAT([BirthDate], 'MM-dd-yyyy')
  	    ,[C].[Name] AS [Hometown]
  	    ,[Email]
    FROM [Accounts] AS [A]
    JOIN [Cities] AS [C]
      ON [A].[CityId] = [C].[Id]
   WHERE [Email] LIKE 'e%'
ORDER BY [C].[Name] ASC

-- Task 6
  SELECT [C].[Name] AS [City]
		,COUNT([H].[Id]) AS [Hotels]
    FROM [Cities] AS [C]
    JOIN [Hotels] AS [H]
      ON [C].[Id] = [H].[CityId]
GROUP BY [C].[Name]
ORDER BY [Hotels] DESC
		,[City] ASC

-- Task 7
WITH CTE_TripsLength AS (
		SELECT [A].[Id] AS [AccountId]
			,CONCAT([A].[FirstName], ' ', [A].[LastName]) AS [FullName]
			,DATEDIFF(DAY, [T].[ArrivalDate], [T].[ReturnDate]) AS [TripLength]
		FROM [Accounts] AS [A]
		JOIN [AccountsTrips] AS [AT]
		ON [A].[Id] = [AT].[AccountId]
		JOIN [Trips] AS [T]
		ON [AT].[TripId] = [T].[Id]
		WHERE [A].[MiddleName] IS NULL
		AND [T].[CancelDate] IS NULL
)

  SELECT [AccountId]
		,[FullName]
		,MAX([TripLength]) AS [LongestTrip]
		,MIN([TripLength]) AS [ShortestTrip]
    FROM [CTE_TripsLength]
GROUP BY [AccountId]
		,[FullName]
ORDER BY [LongestTrip] DESC
		,[ShortestTrip] ASC

-- Task 8
  SELECT TOP(10)
		 [C].[Id] AS [Id]
		,[C].[Name] AS [City]
		,[C].[CountryCode] AS [Country]
		,COUNT(*) AS [Accounts]
    FROM [Cities] AS [C]
    JOIN [Accounts] AS [A]
      ON [C].[Id] = [A].[CityId]
GROUP BY [C].[Id]
		,[C].[Name]
		,[C].[CountryCode]
ORDER BY [Accounts] DESC

-- Task 9
  SELECT [A].[Id] AS [Id]
		,[A].[Email] AS [Email]
		,[C].[Name] AS [City] 
		,COUNT([T].[Id]) AS [Trips]
    FROM [Accounts] AS [A]
	JOIN [Cities] AS [C]
	  ON [A].[CityId] = [C].[Id]
    JOIN [AccountsTrips] AS [AT]
      ON [A].[Id] = [AT].[AccountId]
    JOIN [Trips] AS [T]
      ON [AT].[TripId] = [T].[Id]
    JOIN [Rooms] AS [R]
      ON [T].[RoomId] = [R].[Id]
    JOIN [Hotels] AS [H]
      ON [R].[HotelId] = [H].[Id]
   WHERE [A].[CityId] = [H].[CityId]
GROUP BY [A].[Id]
		,[A].[Email]
		,[C].[Name]
ORDER BY [Trips] DESC
	    ,[Id] ASC

-- Task 10
   SELECT [T].[Id] AS [Id]
		 ,[Full Name] = 
				CASE
					WHEN [A].[MiddleName] IS NULL THEN CONCAT([A].[FirstName], ' ', [A].[LastName])
					ELSE CONCAT([A].[FirstName], ' ', [A].[MiddleName], ' ', [A].[LastName])
				END
		 ,[Origin].[Name] AS [From]
		 ,[Destination].[Name] AS [To]
		 ,[Duration] =
				CASE
					WHEN [T].[CancelDate] IS NOT NULL THEN 'Canceled'
					ELSE CONCAT(DATEDIFF(DAY, [T].[ArrivalDate], [T].[ReturnDate]), ' ', 'days')
				END
     FROM [Trips] AS [T]
     JOIN [AccountsTrips] AS [AT]
       ON [T].[Id] = [AT].[TripId]
	 JOIN [Rooms] AS [R]
	   ON [T].[RoomId] = [R].[Id]
	 JOIN [Hotels] AS [H]
	   ON [R].[HotelId] = [H].[Id]
	 JOIN [Cities] AS [Destination]
	   ON [H].[CityId] = [Destination].[Id]
	 JOIN [Accounts] AS [A]
	   ON [AT].[AccountId] = [A].[Id]
	 JOIN [Cities] AS [Origin]
	   ON [A].[CityId] = [Origin].[Id]
 ORDER BY [Full Name]
		 ,[Id]
GO

-- Task 11
CREATE FUNCTION udf_GetAvailableRoom(@HotelId INT, @Date DATE, @People INT)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	
	DECLARE @RoomId INT
	SET @RoomId = (
			SELECT TOP(1)
				   [R].[Id] 
			  FROM [Rooms] AS [R]
			  JOIN [Trips] AS [T]
			    ON [R].[Id] = [T].[RoomId]
			  JOIN [Hotels] AS [H]
			    ON [R].[HotelId] = [H].[Id]
			 WHERE [R].[HotelId] = @HotelId
			   AND [R].[Beds] >= @People
			   AND ([T].[ArrivalDate] > @Date OR [T].[ReturnDate] < @Date OR [T].[CancelDate] IS NOT NULL )
			   AND [R].[ID] NOT IN (SELECT DISTINCT
										   [R].[Id]
									  FROM [Rooms] AS [R]
									  JOIN [Trips] AS [T]
										ON [R].[Id] = [T].[RoomId]
									 WHERE [R].[HotelId] = 94
									   AND [T].[ArrivalDate] <= CONVERT(DATE, @Date) AND [T].[ReturnDate] >= CONVERT(DATE, @Date) AND [T].[CancelDate] IS NULL)
		  ORDER BY ([H].[BaseRate] + [R].[Price]) * @People DESC)
		
	IF @RoomId IS NULL
		RETURN 'No rooms available'

	DECLARE @RoomType NVARCHAR(MAX)
	SET @RoomType = (SELECT [Type] FROM [Rooms] WHERE [Id] = @RoomId)

	DECLARE @Beds INT
	SET @Beds = (SELECT [Beds] FROM [Rooms] WHERE [Id] = @RoomId)

	DECLARE @TotalCost DECIMAL(18, 2)
	SET @TotalCost = (SELECT ([Hotels].[BaseRate] + [Rooms].[Price]) * @People FROM [Rooms] JOIN [Hotels] ON [Rooms].[HotelId] = [Hotels].[Id] WHERE [Rooms].[Id] = @RoomId)

	RETURN CONCAT('Room ', @RoomId, ': ', @RoomType, ' (', @Beds, ' beds) - $', @TotalCost)
END
GO

-- Task 12
CREATE OR ALTER PROCEDURE usp_SwitchRoom(@TripId INT, @TargetRoomId INT)
AS
	DECLARE @HotelId INT
	SET @HotelId = (SELECT [R].[HotelId] FROM [Trips] AS [T] JOIN [Rooms] AS [R] ON [T].[RoomId] = [R].[Id] WHERE [T].[Id] = @TripId)

	IF (SELECT [Id] FROM [Rooms] WHERE [HotelId] = @HotelId AND [Id] = @TargetRoomId) IS NULL
	BEGIN	
		RAISERROR ('Target room is in another hotel!', 16, 1) 
		RETURN
	END

	DECLARE @NeededBeds INT
	SET @NeededBeds = (SELECT DISTINCT COUNT(AccountId) FROM [Trips] AS [T] JOIN [Rooms] AS [R] ON [T].[RoomId] = [R].[Id] JOIN [AccountsTrips] AS [AT] ON [T].[Id] = [AT].[TripId] WHERE [T].[Id] = @TripId)

	IF @NeededBeds > (SELECT [Beds] FROM [Rooms] WHERE [Id] = @TargetRoomId)
	BEGIN
		RAISERROR ('Not enough beds in target room!', 16, 1) 
		RETURN
	END

	UPDATE [Trips]
	   SET [RoomId] = @TargetRoomId
	 WHERE [Id] = @TripId
GO
