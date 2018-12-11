  SELECT Names,
         Email,
		 Bill,
		 Town
    FROM (SELECT c.Id,
	             CONCAT(c.FirstName, ' ', c.LastName) AS Names,
                 c.Email,
          	     o.Bill,
          	     t.[Name] AS Town,
  	      	     ROW_NUMBER() OVER(PARTITION BY t.[Name] ORDER BY o.Bill DESC) AS [Number]
            FROM Orders AS o
            JOIN Clients AS c ON c.Id = o.ClientId
            JOIN Towns AS t ON t.Id = o.TownId
           WHERE c.CardValidity < o.CollectionDate
             AND o.ReturnDate IS NOT NULL) AS DebtByTown
   WHERE Number IN (1, 2)
ORDER BY Town ASC,
         Bill ASC,
		 Id ASC
		 