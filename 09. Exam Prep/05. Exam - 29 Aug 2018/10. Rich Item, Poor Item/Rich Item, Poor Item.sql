SELECT TOP 10
           o.Id AS OrderId,
	       MAX(i.Price) AS ExpensivePrice,
		   MIN(i.Price) AS CheapPrice
      FROM Orders AS o
INNER JOIN OrderItems AS oi ON oi.OrderId = o.Id
INNER JOIN Items AS i ON i.Id = oi.ItemId
  GROUP BY o.Id
  ORDER BY ExpensivePrice DESC,
           o.Id ASC