  SELECT CONCAT(m.FirstName, ' ', m.LastName) AS Mechanic,
         AVG(DATEDIFF(DAY, j.IssueDate, j.FinishDate)) AS [Average Days]
    FROM Mechanics AS M
    JOIN Jobs AS J
      ON j.MechanicId = m.MechanicId
   WHERE j.[Status] = 'Finished'
GROUP BY m.MechanicId,
         m.FirstName,
		 m.LastName
ORDER BY m.MechanicId