 WITH CTE AS
  (SELECT i.Id AS [Item Id],
         i.[Name] AS Item,
         SUM(oi.Quantity) AS [Count],
		 SUM(oi.Quantity * i.Price) AS TotalPrice
    FROM Items AS i
LEFT JOIN Categories AS c ON c.Id = i.CategoryId
LEFT JOIN OrderItems AS oi ON oi.ItemId = i.Id
LEFT JOIN Orders AS o ON o.Id = oi.OrderId
GROUP BY i.Id, 
         i.[Name])

SELECT CTE.Item,
       c.[Name] AS Category,
	   CTE.[Count],
	   CTE.TotalPrice
  FROM CTE
  JOIN Items AS i ON i.Id = CTE.[Item Id]
  JOIN Categories AS c ON c.Id = i.CategoryId
ORDER BY TotalPrice DESC,
         [Count] DESC