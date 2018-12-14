SELECT TOP 10 
           CONCAT(e.FirstName, ' ', e.LastName) AS [Full Name],
           SUM(oi.Quantity * i.Price) AS [Total Price],
 		   SUM(oi.Quantity) AS Items
      FROM Employees AS e
 LEFT JOIN Orders AS o ON o.EmployeeId = e.Id
       AND o.[DateTime] < '2018-06-15'
 LEFT JOIN OrderItems AS oi ON oi.OrderId = o.Id
 LEFT JOIN Items AS i ON i.Id = oi.ItemId
  GROUP BY e.Id, 
           e.FirstName, 
 		   e.LastName
  ORDER BY [Total Price] DESC,
           Items DESC