SELECT TownName,
        CONVERT(INT, FLOOR(MaleCount * 100.00 / (ISNULL(MaleCount, 0) + ISNULL(FemaleCount, 0)))) AS MalePercent,
		CONVERT(INT, FLOOR(FemaleCount * 100.00 / (ISNULL(MaleCount, 0) + ISNULL(FemaleCount, 0)))) AS FemalePercent
  FROM (  SELECT TownName,
                 MAX(CASE WHEN Gender = 'M' THEN [Count] ELSE NULL END) AS [MaleCount],
                 MAX(CASE WHEN Gender = 'F' THEN [Count] ELSE NULL END) AS [FemaleCount]
            FROM (   SELECT t.[Name] AS TownName,
                            c.Gender,
                  		   COUNT(c.Id) AS [Count]
                       FROM Towns AS t
                  LEFT JOIN Orders AS o ON o.TownId = t.Id
                  LEFT JOIN Clients AS c ON c.Id = o.ClientId
                   GROUP BY t.[Name],
                            c.Gender)AS GenderByTown
        GROUP BY TownName) AS GenderByTownFormated