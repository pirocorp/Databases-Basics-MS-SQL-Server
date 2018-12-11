WITH CTE_RankedOrdersByType AS (  SELECT c.Id,
                                         CONCAT(c.FirstName, ' ', c.LastName) AS [Names], 
                                         m.Class,
                                		 COUNT(v.Id) AS [Orders Count],
                                		 DENSE_RANK() OVER(PARTITION BY CONCAT(c.FirstName, ' ', c.LastName) ORDER BY COUNT(v.Id) DESC) AS [Rank]
                                    FROM Clients AS c
                                    JOIN Orders AS o ON o.ClientId = c.Id
                                    JOIN Vehicles AS v ON v.Id = o.VehicleId
                                    JOIN Models AS m ON m.Id = v.ModelId
                                GROUP BY c.Id,
                                         CONCAT(c.FirstName, ' ', c.LastName),
                                		 m.Class)
  SELECT Names,
         Class
    FROM CTE_RankedOrdersByType
   WHERE [Rank] = 1
ORDER BY Names ASC,
         Class ASC,
		 Id ASC