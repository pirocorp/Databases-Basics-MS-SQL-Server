  SELECT TOP 1 WITH TIES
         co.[Name],
         AVG(Rate) AS FeedbackRate
    FROM Feedbacks AS f
    JOIN Customers AS cu ON cu.Id = f.CustomerId
	JOIN Countries AS co ON co.Id = cu.CountryId
GROUP BY co.[Name]
ORDER BY FeedbackRate DESC