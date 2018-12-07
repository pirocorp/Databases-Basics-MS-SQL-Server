    SELECT u.Username, 
	       g.[Name] AS [Game],
		   MAX(c.[Name]) AS [Character],
		   MAX(cs.Strength) +  MAX(bs.Strength) + SUM(ist.Strength) AS [Strength],
		   MAX(cs.Defence) +  MAX(bs.Defence) + SUM(ist.Defence) AS [Defence],
		   MAX(cs.Speed) + MAX(bs.Speed) + SUM(ist.Speed) AS [Speed],
		   MAX(cs.Mind) + MAX(bs.Mind) + SUM(ist.Mind) AS [Mind],
		   MAX(cs.Luck) + MAX(bs.Luck) + SUM(ist.Luck) AS [Luck]
      FROM UsersGames AS ug
INNER JOIN Games AS g ON g.Id = ug.GameId
INNER JOIN Users AS u ON u.Id = ug.UserId
INNER JOIN Characters AS c ON c.Id = ug.CharacterId
INNER JOIN [Statistics] AS cs ON cs.Id = c.StatisticId
INNER JOIN GameTypes AS gt ON gt.Id = g.GameTypeId
INNER JOIN [Statistics] AS bs ON bs.Id = gt.BonusStatsId
INNER JOIN UserGameItems AS ugi ON ugi.UserGameId = ug.Id
INNER JOIN Items AS i ON i.Id = ugi.ItemId
INNER JOIN [Statistics] AS ist ON ist.Id = i.StatisticId
  GROUP BY u.Username, g.[Name]
  ORDER BY Strength DESC, Defence DESC, Speed DESC, Mind DESC, Luck DESC
        GO