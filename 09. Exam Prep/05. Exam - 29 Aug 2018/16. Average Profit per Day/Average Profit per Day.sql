SELECT DATEPART(DAY, o.[DateTime]) AS [Day],
       CONVERT(DECIMAL(15, 2), ROUND(AVG(oi.Quantity * i.Price), 2)) AS [Total profit]
  FROM Orders AS o
  JOIN OrderItems AS oi ON oi.OrderId = o.Id
  JOIN Items AS i ON i.Id = oi.ItemId
GROUP BY DATEPART(DAY, o.[DateTime])
ORDER BY [Day]