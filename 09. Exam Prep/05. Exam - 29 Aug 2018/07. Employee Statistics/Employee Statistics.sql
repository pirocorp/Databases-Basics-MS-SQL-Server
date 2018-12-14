    SELECT FirstName,
	       LastName,
		   COUNT(o.Id) AS [Count]
      FROM Employees AS e
INNER JOIN Orders AS o ON o.EmployeeId = e.Id
  GROUP BY e.Id,
           e.FirstName,
		   e.LastName
  ORDER BY [Count] DESC,
           FirstName