-- Task 1
USE Diablo
GO

  SELECT SUBSTRING([Email], CHARINDEX('@', [Email]) + 1, LEN([Email])) AS [Email Provider]
	    ,COUNT(*) AS [Number Of Users]
    FROM [Users]
GROUP BY SUBSTRING([Email], CHARINDEX('@', [Email]) + 1, LEN([Email]))
ORDER BY [Number Of Users] DESC
        ,[Email Provider] ASC
		
-- Task 2
SELECT
  	     [G].[Name] AS [Game]
  	    ,[GT].[Name] AS [Game Type]
  	    ,[U].[Username] AS [Username]
  	    ,[UG].[Level] AS [Level]
  	    ,[UG].[Cash] AS [Cash]
  	    ,[C].[Name] AS [Character]
    FROM [UsersGames] AS [UG]
    JOIN [Games] AS [G]
      ON [UG].[GameId] = [G].[Id]
    JOIN [GameTypes] AS [GT]
      ON [G].[GameTypeId] = [GT].[Id]
    JOIN [Users] AS [U]
      ON [UG].[UserId] = [U].[Id]
    JOIN [Characters] AS [C]
      ON [UG].[CharacterId] = [C].[Id]
ORDER BY [Level] DESC
        ,[Username] ASC
		,[Game] ASC

-- Task 3
  SELECT  
         [U].[Username]
   	    ,[G].[Name] AS [Game]
		,COUNT(*) AS [Items Count]
		,SUM([I].[Price]) AS [Items Price]
    FROM [UserGameItems] AS [UGI]
    JOIN [UsersGames] AS [UG]
      ON [UGI].[UserGameId] = [UG].[Id]
    JOIN [Users] AS [U]
      ON [UG].[UserId] = [U].[Id]
    JOIN [Games] AS [G]
      ON [UG].[GameId] = [G].[Id]
	JOIN [Items] AS [I]
	  ON [UGI].[ItemId] = [I].[Id]
GROUP BY [U].[Username]
		,[G].[Name]
  HAVING COUNT(*) >= 10
ORDER BY [Items Count] DESC
        ,[Items Price] DESC
		,[Username] ASC

-- Task 4
  SELECT [U].[Username] AS [Username]
  	    ,[G].[Name] AS [Game]
  	    ,MAX([C].[Name]) AS [Character]  	  
		,SUM([ItemStats].[Strength]) + MAX([CharacterStats].[Strength]) + MAX([GameStats].[Strength]) AS [Strength]
		,SUM([ItemStats].[Defence]) + MAX([CharacterStats].[Defence]) + MAX([GameStats].[Defence]) AS [Defence]
		,SUM([ItemStats].[Speed]) + MAX([CharacterStats].[Speed]) + MAX([GameStats].[Speed]) AS [Speed]
		,SUM([ItemStats].[Mind]) + MAX([CharacterStats].[Mind]) + MAX([GameStats].[Mind]) AS [Mind]
		,SUM([ItemStats].[Luck]) + MAX([CharacterStats].[Luck]) + MAX([GameStats].[Luck]) AS [Luck]
    FROM [UsersGames] AS [UG]
    JOIN [Characters] AS [C]
      ON [UG].[CharacterId] = [C].[Id]
    JOIN [Users] AS [U]
      ON [UG].[UserId] = [U].[Id]
    JOIN [Games] AS [G]
      ON [UG].[GameId] = [G].[Id]
	JOIN [GameTypes] AS [GT]
	  ON [G].[GameTypeId] = [GT].[Id]
    JOIN [UserGameItems] AS [UGI]
      ON [UG].[Id] = [UGI].[UserGameId]
	JOIN [Items] AS [I]
	  ON [UGI].[ItemId] = [I].[Id]
	JOIN [Statistics] AS [ItemStats]
	  ON [I].[StatisticId] = [ItemStats].[Id]
	JOIN [Statistics] AS [CharacterStats]
	  ON [C].[StatisticId] = [CharacterStats].[Id]
	JOIN [Statistics] AS [GameStats]
	  ON [GT].[BonusStatsId] = [GameStats].[Id]
GROUP BY [U].[Username]
		,[G].[Name]
ORDER BY [Strength] DESC
		,[Defence] DESC
		,[Speed] DESC
		,[Mind] DESC
		,[Luck] DESC

-- Task 5
  SELECT [I].[Name]
        ,[I].[Price]
        ,[I].[MinLevel]
        ,[IS].[Strength]
        ,[IS].[Defence]
        ,[IS].[Speed]
        ,[IS].[Luck]
        ,[IS].[Mind]
    FROM [Items] AS [I]
    JOIN [Statistics] AS [IS]
      ON [I].[StatisticId] = [IS].[Id]
   WHERE [IS].[Mind] > (SELECT AVG([Mind]) 
						  FROM [Items] AS [I]
						  JOIN [Statistics] AS [IS]
							ON [I].[StatisticId] = [IS].[Id])
	 AND [IS].[Luck] > (SELECT AVG([Luck]) 
						  FROM [Items] AS [I]
						  JOIN [Statistics] AS [IS]
							ON [I].[StatisticId] = [IS].[Id])
	AND [IS].[Speed] > (SELECT AVG([Speed]) 
						  FROM [Items] AS [I]
						  JOIN [Statistics] AS [IS]
							ON [I].[StatisticId] = [IS].[Id])
ORDER BY [I].[Name]

-- Task 6
  SELECT [I].[Name] AS [Item]
        ,[I].[Price]
        ,[I].[MinLevel]
        ,[GT].[Name] AS [Forbidden Game Type]
    FROM [Items] AS [I]
LEFT JOIN [GameTypeForbiddenItems] AS [F]
      ON [I].[Id] = [F].[ItemId]
LEFT JOIN [GameTypes] AS [GT]
      ON [F].[GameTypeId] = [GT].[Id]
ORDER BY [GT].[Name] DESC
		,[I].[Name] ASC

-- Task 7
DECLARE @AlexGameId INT
DECLARE @Total MONEY
SET @AlexGameId = (SELECT [Id]
					 FROM [UsersGames] AS [UG]
					WHERE [UserId] = (SELECT [Id] FROM [Users] WHERE [Username] = 'Alex')
					  AND [GameId] = (SELECT [Id] FROM [Games] WHERE [Name] = 'Edinburgh'))

SET @Total = (SELECT SUM(Price)
			    FROM [Items] AS [I]
			   WHERE [I].[Name] IN ('Blackguard',
									'Bottomless Potion of Amplification', 
								    'Eye of Etlich (Diablo III)', 
								    'Gem of Efficacious Toxin', 
								    'Golden Gorget of Leoric', 
								    'Hellfire Amulet'))
	UPDATE [UsersGames]
	   SET [Cash] -= @Total
	 WHERE [Id] = @AlexGameId

	INSERT INTO UserGameItems
	SELECT [Id] AS [ItemId]
		  ,@AlexGameId AS [UserGameId]
	  FROM [Items] AS [I]
	 WHERE [I].[Name] IN ('Blackguard',
						  'Bottomless Potion of Amplification', 
						  'Eye of Etlich (Diablo III)', 
						  'Gem of Efficacious Toxin', 
						  'Golden Gorget of Leoric', 
						  'Hellfire Amulet')

  SELECT [U].[Username]
        ,[G].[Name]
		,[UG].[Cash]
		,[I].[Name] AS [Item Name]
    FROM [UsersGames] AS [UG]
    JOIN [Games] AS [G]
      ON [UG].[GameId] = [G].[Id]
    JOIN [Users] AS [U]
      ON [UG].[UserId] = [U].[Id]
	JOIN [UserGameItems] AS [UGI]
	  ON [UG].[Id] = [UGI].[UserGameId]
	JOIN [Items] AS [I]
	  ON [UGI].[ItemId] = [I].[Id]
   WHERE [G].[Name] = 'Edinburgh'
ORDER BY [Item Name]
  
-- Task 8
USE [Geography]
GO

  SELECT [PeakName]
		,[MountainRange]
		,[Elevation]
	FROM [Peaks] AS [P]
	JOIN [Mountains] AS [M]
      ON [P].[MountainId] = [M].[Id]
ORDER BY [Elevation] DESC
		,[PeakName]

-- Task 9
  SELECT [PeakName]
		,[MountainRange]
		,[CountryName]
		,[ContinentName]
	FROM [Peaks] AS [P]
	JOIN [Mountains] AS [M]
      ON [P].[MountainId] = [M].[Id]
	JOIN [MountainsCountries] AS [MC]
	  ON [M].[Id] = [MC].[MountainId]
	JOIN [Countries] AS [C]
	  ON [MC].[CountryCode] = [C].[CountryCode]
	JOIN [Continents] AS [K]
	  ON [C].[ContinentCode] = [K].[ContinentCode]
ORDER BY [PeakName], [CountryName]

-- Task 10
WITH CTE_RiversByCountry AS(
	   SELECT
			  [C].[CountryCode]
			 ,[C].[CountryName] 
			 ,[C].[ContinentCode]
			 ,COUNT(RiverName) AS [RiversCount]
			 ,ISNULL(SUM([Length]), 0) AS [TotalLength]
		 FROM [Countries] AS [C]
	LEFT JOIN [CountriesRivers] AS [CR]
		   ON [C].[CountryCode] = [CR].[CountryCode]
	LEFT JOIN [Rivers] AS [R]
		   ON [CR].[RiverId] = [R].[Id]
	 GROUP BY [C].[CountryCode]
			 ,[C].[CountryName]
			 ,[C].[ContinentCode]
)

SELECT [CountryName]
	  ,[ContinentName]
	  ,[RiversCount]
	  ,[TotalLength]
  FROM CTE_RiversByCountry AS [C]
  JOIN [Continents] AS [K]
    ON [C].[ContinentCode] = [K].[ContinentCode]
ORDER BY [RiversCount] DESC
		,[TotalLength] DESC
		,[CountryName] 

-- Task 11
  SELECT [C].[CurrencyCode] AS [CurrencyCode]
		,[C].[Description] AS [Currency]
		,COUNT([K].[CountryCode]) AS [NumberOfCountries]
    FROM Currencies AS [C]
LEFT JOIN Countries AS [K]
      ON [C].[CurrencyCode] = [K].[CurrencyCode]
GROUP BY [C].[CurrencyCode]
		,[C].[Description]
ORDER BY [NumberOfCountries] DESC
		,[Currency]

-- Task 12
   SELECT [Continents].[ContinentName] AS [ContinentName]
		 ,SUM([Countries].[AreaInSqKm]) AS [CountriesArea]
		 ,SUM(CONVERT(BIGINT, [Countries].[Population])) AS [CountriesPopulation]
	 FROM [Continents] 
LEFT JOIN [Countries]
	   ON [Continents].[ContinentCode] = [Countries].[ContinentCode]
 GROUP BY [Continents].[ContinentName]
 ORDER BY [CountriesPopulation] DESC

 -- Task 13
 CREATE TABLE [Monasteries](
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(MAX),
	[CountryCode] NVARCHAR(MAX),
 )

INSERT INTO Monasteries(Name, CountryCode) VALUES
('Rila Monastery “St. Ivan of Rila”', 'BG'), 
('Bachkovo Monastery “Virgin Mary”', 'BG'),
('Troyan Monastery “Holy Mother''s Assumption”', 'BG'),
('Kopan Monastery', 'NP'),
('Thrangu Tashi Yangtse Monastery', 'NP'),
('Shechen Tennyi Dargyeling Monastery', 'NP'),
('Benchen Monastery', 'NP'),
('Southern Shaolin Monastery', 'CN'),
('Dabei Monastery', 'CN'),
('Wa Sau Toi', 'CN'),
('Lhunshigyia Monastery', 'CN'),
('Rakya Monastery', 'CN'),
('Monasteries of Meteora', 'GR'),
('The Holy Monastery of Stavronikita', 'GR'),
('Taung Kalat Monastery', 'MM'),
('Pa-Auk Forest Monastery', 'MM'),
('Taktsang Palphug Monastery', 'BT'),
('Sümela Monastery', 'TR')

ALTER TABLE Countries
	ADD IsDeleted BIT DEFAULT 0 NOT NULL

  UPDATE [Countries]
     SET [Countries].[IsDeleted] = 1
   WHERE [Countries].[CountryCode] IN (SELECT [C].[CountryCode] 
                             FROM [Countries] AS [C]
							 JOIN [CountriesRivers] AS [CR]
                               ON [C].[CountryCode] = [CR].[CountryCode]
                         GROUP BY [C].[CountryCode]
                           HAVING COUNT([CR].[RiverId]) > 3)


  SELECT [M].[Name]  AS [Monastery]
    	,[C].[CountryName] AS [Country]
    FROM [Monasteries] AS [M]
    JOIN [Countries] AS [C]
      ON [M].[CountryCode] = [C].[CountryCode]
   WHERE [C].[IsDeleted] = 0
ORDER BY [Monastery]

-- Task 14
UPDATE [Countries]
   SET [Countries].[CountryName] = 'Burma'
 WHERE [Countries].[CountryName] = 'Myanmar'

DECLARE @tanzaniaCode NVARCHAR(MAX)
SET @tanzaniaCode = (SELECT [CountryCode] FROM [Countries] WHERE [Countries].[CountryName] = 'Tanzania')

DECLARE @myanmarCode NVARCHAR(MAX)
SET @myanmarCode = (SELECT [CountryCode] FROM [Countries] WHERE [Countries].[CountryName] = 'Myanmar')

INSERT INTO [Monasteries]
VALUES('Hanga Abbey', @tanzaniaCode)
      ,('Myin-Tin-Daik', @myanmarCode)

   SELECT [K].[ContinentName] AS [ContinentName]
		 ,[C].[CountryName] AS [CountryName]
		 ,COUNT([M].[Name]) AS [MonasteriesCount]
     FROM [Countries] AS [C]
     JOIN [Continents] AS [K]
       ON [C].[ContinentCode] = [K].[ContinentCode]
LEFT JOIN [Monasteries] AS [M]
       ON [C].[CountryCode] = [M].[CountryCode]
	WHERE [C].[IsDeleted] = 0
 GROUP BY [ContinentName]
		 ,[CountryName]
 ORDER BY [MonasteriesCount] DESC
		 ,[CountryName]