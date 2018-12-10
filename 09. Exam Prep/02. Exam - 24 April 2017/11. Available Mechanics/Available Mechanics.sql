  SELECT CONCAT(m.FirstName, ' ', m.LastName) AS [Available]
    FROM Mechanics AS m
   WHERE m.MechanicId NOT IN (   SELECT m.MechanicId
                                 FROM Mechanics AS m
                            LEFT JOIN Jobs AS j
                                   ON j.MechanicId = m.MechanicId
                            	  WHERE j.[Status] != 'Finished'
                             GROUP BY m.MechanicId)
ORDER BY m.MechanicId
