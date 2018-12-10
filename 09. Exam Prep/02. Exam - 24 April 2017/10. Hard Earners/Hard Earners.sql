  SELECT CONCAT(m.FirstName, ' ', m.LastName) AS Mechanic,
         COUNT(j.JobId) AS Jobs 
    FROM Mechanics AS m
    JOIN Jobs AS j
      ON j.MechanicId = m.MechanicId
   WHERE j.[Status] != 'Finished'
GROUP BY m.MechanicId,
		 m.FirstName,
		 m.LastName
  HAVING COUNT(j.JobId) > 1
ORDER BY Jobs DESC,
         m.MechanicId ASC
  
         