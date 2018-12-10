  SELECT CONCAT(c.FirstName, ' ', c.LastName) AS [Client],
         DATEDIFF(DAY, j.IssueDate, '04-24-2017') AS [Days going],
  	   [Status]
    FROM Clients AS c
    JOIN Jobs AS j
      ON j.ClientId = c.ClientId
   WHERE j.[Status] != 'Finished'
ORDER BY [Days going] DESC,
         c.ClientId
