SELECT TOP 1 
           o.Id AS OrderId,
	       SUM(i.Price * oi.Quantity) AS TotalPrice
      FROM Orders AS o
INNER JOIN OrderItems AS oi ON oi.OrderId = o.Id
INNER JOIN Items AS i ON i.Id = oi.ItemId
  GROUP BY o.Id
  ORDER BY TotalPrice DESC