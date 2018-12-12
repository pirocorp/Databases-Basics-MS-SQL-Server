WITH CTE_RankedDistributorsByCountry AS (
SELECT c.[Name] AS CountryName, 
       d.[Name] AS [DisributorName],
       COUNT(i.Id) AS [Ingredients Count],
	   DENSE_RANK() OVER(PARTITION BY c.[Name] ORDER BY COUNT(i.Id) DESC) AS [Rank]
  FROM Distributors AS d
  LEFT JOIN Ingredients AS i ON i.DistributorId = d.Id
  LEFT JOIN Countries AS c ON c.Id = d.CountryId
GROUP BY c.[Name],
         d.[Name])

  SELECT CountryName,
         DisributorName 
    FROM CTE_RankedDistributorsByCountry
   WHERE [Rank] = 1
ORDER BY CountryName,
         DisributorName