 SELECT [Category Name],
		[Reports Number],
		CASE
			WHEN [StatusChooser] > 1 THEN 'equal'
			ELSE [Status]
		 END AS [Main Status]
   FROM (SELECT [Category Name],
                AVG([Total Reports Number]) AS [Reports Number],
       		    MIN([Reprt Type])[Status],
       		    SUM([Rank]) AS [StatusChooser]
           FROM (SELECT *,
                        SUM([Reports Number]) OVER(PARTITION BY [Category Name]) AS [Total Reports Number],
                        DENSE_RANK() OVER(PARTITION BY [Category Name] ORDER BY [Reports Number] DESC) AS [Rank]
                   FROM (SELECT c.[Name] AS [Category Name],
                                s.Label AS [Reprt Type],
       		                    COUNT(r.Id) AS [Reports Number]         
                           FROM Reports AS r
                           JOIN Categories AS c
                             ON c.Id = r.CategoryId
                           JOIN [Status] AS s
                             ON s.Id = r.StatusId
                          WHERE r.StatusId IN (1, 2)
                       GROUP BY c.[Name],
                                s.Label) AS Level1) AS Level2
          WHERE [Rank] = 1
       GROUP BY [Category Name]) AS Level3
