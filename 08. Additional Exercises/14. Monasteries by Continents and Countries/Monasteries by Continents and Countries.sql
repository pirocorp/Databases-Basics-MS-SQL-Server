--1. Write and execute a SQL command that changes the country named "Myanmar" to its other name "Burma".
UPDATE Countries
   SET CountryName = 'Burma'
 WHERE CountryName = 'Myanmar'

--2.	Add a new monastery holding the following information: Name="Hanga Abbey", Country="Tanzania".
INSERT INTO Monasteries([Name], CountryCode) VALUES
('Hanga Abbey', (SELECT CountryCode
                   FROM Countries
                  WHERE [CountryName] = 'Tanzania'))

--3 Add a new monastery holding the following information: Name="Myin-Tin-Daik", Country="Myanmar".
INSERT INTO Monasteries([Name], CountryCode) VALUES
('Myin-Tin-Daik', (SELECT CountryCode
                   FROM Countries
                  WHERE [CountryName] IN ('Myanmar')))

--4. Find the count of monasteries for each continent and not deleted country. 
    SELECT co.ContinentName AS [ContinentName],
           cu.CountryName AS [CountryName],
    	   COUNT(m.[Name]) AS [MonasteriesCount]
      FROM Monasteries AS m
RIGHT JOIN Countries AS cu
        ON cu.CountryCode = m.CountryCode
      JOIN Continents AS co
        ON co.ContinentCode = cu.ContinentCode
	 WHERE cu.IsDeleted = 0
  GROUP BY co.ContinentName,
           cu.CountryName
  ORDER BY [MonasteriesCount] DESC,
           [CountryName]