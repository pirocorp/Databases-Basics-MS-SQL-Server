  SELECT f.ProductId,
         CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
		 f.[Description] AS FeedbackDescription
    FROM Feedbacks AS f
	JOIN Customers AS c ON c.Id = f.CustomerId
   WHERE CustomerId IN (  SELECT CustomerId
                            FROM Feedbacks
                        GROUP BY CustomerId
                          HAVING COUNT(Id) >= 3)
ORDER BY f.ProductId,
         CustomerName,
		 f.Id