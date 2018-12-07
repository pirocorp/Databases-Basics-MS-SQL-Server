   SELECT c.CountryName,
          cc.ContinentName,
          COUNT(r.RiverName) AS [RiversCount],
		  CASE   
           WHEN SUM(r.[Length]) IS NULL THEN 0 
           ELSE SUM(r.[Length])
          END AS [TotalLength]
     FROM Countries AS c
LEFT JOIN CountriesRivers AS cr
       ON cr.CountryCode = c.CountryCode
LEFT JOIN Rivers AS r
       ON r.Id = cr.RiverId
LEFT JOIN Continents AS cc
       ON cc.ContinentCode = c.ContinentCode
 GROUP BY c.CountryName, cc.ContinentName
 ORDER BY [RiversCount] DESC,
          [TotalLength] DESC,
		  c.CountryName