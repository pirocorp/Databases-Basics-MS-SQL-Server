    SELECT u.Username AS [Username],
	       g.[Name] AS [Game],
		   COUNT(i.Id) AS [Items Count],
		   SUM(i.Price) AS [Cash]
      FROM UserGameItems AS ugi
INNER JOIN Items AS i
        ON i.Id = ugi.ItemId
INNER JOIN UsersGames AS ug
        ON ug.Id = ugi.UserGameId
INNER JOIN Users AS u
        ON u.Id = ug.UserId
INNER JOIN Games AS g
        ON g.Id = ug.GameId
  GROUP BY u.Username, 
           g.[Name]
    HAVING COUNT(i.Id) >= 10
  ORDER BY [Items Count] DESC,
           [Cash] DESC,
		   [Username]