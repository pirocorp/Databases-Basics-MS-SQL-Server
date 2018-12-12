   SELECT TOP 10
          p.[Name],
          p.[Description],
          ISNULL(AVG(f.Rate), 0) AS AverageRate,
		  COUNT(f.Id) AS FeedbacksAmount
     FROM Products AS p
LEFT JOIN Feedbacks AS f ON f.ProductId = p.Id
 GROUP BY p.[Name], p.[Description]
 ORDER BY AverageRate DESC,
          FeedbacksAmount DESC