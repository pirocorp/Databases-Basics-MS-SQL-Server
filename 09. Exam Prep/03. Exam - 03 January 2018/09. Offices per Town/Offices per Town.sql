   SELECT t.[Name] AS [TownName],
          ISNULL(COUNT(o.Id), 0) AS OfficesNumber
     FROM Towns AS t
LEFT JOIN Offices AS o
       ON o.TownId = t.Id
 GROUP BY t.[Name]
 ORDER BY OfficesNumber DESC,
          [TownName] ASC