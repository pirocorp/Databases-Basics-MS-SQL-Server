   SELECT m.ModelId,
          m.[Name],
		  CONCAT(ISNULL(AVG(DATEDIFF(DAY, j.IssueDate, j.FinishDate)), 0), ' days') AS [Average Service Time]
     FROM Models AS m
LEFT JOIN Jobs AS j
       ON j.ModelId = m.ModelId
    WHERE j.FinishDate IS NOT NULL
 GROUP BY m.ModelId,
          m.[Name]
 ORDER BY AVG(DATEDIFF(DAY, j.IssueDate, j.FinishDate)) ASC