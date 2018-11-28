SELECT TOP 5
	       c.CountryName,
	       r.RiverName
      FROM Countries AS c
 LEFT JOIN CountriesRivers AS cr
        ON cr.CountryCode = c.CountryCode
 LEFT JOIN Rivers AS r
        ON r.Id = cr.RiverId
INNER JOIN Continents AS cn
        ON cn.ContinentCode = c.ContinentCode
	 WHERE cn.ContinentName = 'Africa'
  ORDER BY c.CountryName ASC
        GO
