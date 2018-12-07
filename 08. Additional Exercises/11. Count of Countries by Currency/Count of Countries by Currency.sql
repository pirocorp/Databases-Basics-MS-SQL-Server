    SELECT fx.CurrencyCode AS [CurrencyCode],
           fx.[Description] AS [Currency],
  	       COUNT(c.CountryCode) AS [NumberOfCountries]
      FROM Countries AS c
RIGHT JOIN Currencies AS fx
        ON fx.CurrencyCode = c.CurrencyCode
  GROUP BY fx.CurrencyCode, 
           fx.[Description]
  ORDER BY [NumberOfCountries] DESC,
           fx.[Description]