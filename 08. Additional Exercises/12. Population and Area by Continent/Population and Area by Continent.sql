   SELECT co.ContinentName,
		  SUM(cu.AreaInSqKm) AS [CountriesArea],
		  SUM(CONVERT(BIGINT, cu.[Population])) AS [CountriesPopulation]
     FROM Continents AS co
LEFT JOIN Countries AS cu
       ON cu.ContinentCode = co.ContinentCode
 GROUP BY co.ContinentName
 ORDER BY [CountriesPopulation] DESC