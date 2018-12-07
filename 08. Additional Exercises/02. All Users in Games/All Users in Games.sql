    SELECT g.[Name] AS [Game],
	       gt.[Name] AS [Game Type],
		   u.Username AS [Username],
		   ug.[Level] AS [Level],
		   ug.[Cash] AS [Cash],
		   c.[Name] AS [Character]
      FROM UsersGames AS ug
INNER JOIN Games AS g
        ON g.Id = ug.GameId
INNER JOIN Users AS u
        ON u.Id = ug.UserId
INNER JOIN GameTypes AS gt
        ON gt.Id = g.GameTypeId
INNER JOIN Characters AS c
        ON c.Id = ug.CharacterId
  ORDER BY [Level] DESC,
           [Username],
		   [Game]
