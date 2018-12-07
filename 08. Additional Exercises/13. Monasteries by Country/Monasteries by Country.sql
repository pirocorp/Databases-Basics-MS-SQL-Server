--1. Create a table Monasteries
CREATE TABLE Monasteries(
	Id INT IDENTITY,
	[Name] NVARCHAR(64) NOT NULL,
	CountryCode CHAR(2) NOT NULL

    CONSTRAINT PK_Monasteries
	PRIMARY KEY(Id)

	CONSTRAINT FK_Monasteries
	FOREIGN KEY(CountryCode)
	REFERENCES Countries(CountryCode)
)

--2. Execute the following SQL script (it should pass without any errors)
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
('S?mela Monastery', 'TR')

--3. Write a SQL command to add a new Boolean column
ALTER TABLE Countries 
ADD IsDeleted  BIT DEFAULT 0 NOT NULL 

--4.Write and execute a SQL command to mark as deleted all countries that have more than 3 rivers.
UPDATE Countries
   SET [IsDeleted] = 1
 WHERE CountryCode IN(SELECT a.Code 
	                    FROM (  SELECT c.CountryCode AS Code, 
		                         COUNT (cr.RiverId) AS CountRivers FROM Countries AS c
                                  JOIN CountriesRivers AS cr ON cr.CountryCode = c.CountryCode
                              GROUP BY c.CountryCode) AS a
                       WHERE a.CountRivers > 3)

--5.Write a query to display all monasteries along with their countries sorted by monastery name. Skip all deleted countries and their monasteries.
   SELECT m.[Name] AS [Monastery],
          c.CountryName AS [Country]
     FROM Monasteries AS m
LEFT JOIN Countries AS c
       ON c.CountryCode = m.CountryCode
	WHERE c.IsDeleted = 0
 ORDER BY [Monastery]