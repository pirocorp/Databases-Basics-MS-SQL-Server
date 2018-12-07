   DECLARE @AverageMind INT = (SELECT AVG(s.Mind)
                                 FROM Items AS i
                           INNER JOIN [Statistics] AS s
                                   ON s.Id = i.StatisticId)

   DECLARE @AverageLuck INT = (SELECT AVG(s.Luck)
                                 FROM Items AS i
                           INNER JOIN [Statistics] AS s
                                   ON s.Id = i.StatisticId)

   DECLARE @AverageSpeed INT = (SELECT AVG(s.Speed)
                                 FROM Items AS i
                           INNER JOIN [Statistics] AS s
                                   ON s.Id = i.StatisticId)
   	
	SELECT i.[Name],
	       i.Price,
		   i.MinLevel,
		   s.Strength,
		   s.Defence,
		   s.Speed,
		   s.Luck,
		   s.Mind
      FROM Items AS i
INNER JOIN [Statistics] AS s
        ON s.Id = i.StatisticId
	 WHERE s.Mind > @AverageMind
	   AND s.Luck > @AverageLuck
	   AND s.Speed > @AverageSpeed
  ORDER BY i.[Name]
