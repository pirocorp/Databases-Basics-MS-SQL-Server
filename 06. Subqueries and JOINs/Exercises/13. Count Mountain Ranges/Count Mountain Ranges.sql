    SELECT c.CountryCode,
	       COUNT(m.MountainRange) AS MountainRanges
      FROM Countries AS c
INNER JOIN MountainsCountries AS mc
        ON mc.CountryCode = c.CountryCode
INNER JOIN Mountains AS m
        ON m.Id = mc.MountainId
     WHERE c.CountryCode IN ('BG', 'US', 'RU')
  GROUP BY c.CountryCode
        GO