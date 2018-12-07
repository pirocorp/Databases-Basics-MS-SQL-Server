  SELECT [Department Name],
         [Category Name],
		 CONVERT(INT, ROUND([Report Count] * 100.0 /SUM([Report Count]) OVER(PARTITION BY [Department Name]), 0)) 
	  AS [Percentage]
    FROM (  SELECT d.[Name] AS [Department Name],
                   c.[Name] AS [Category Name],
		           COUNT(r.Id) AS [Report Count]		 
              FROM Departments AS d
              JOIN Categories AS c
                ON c.DepartmentId = d.Id
	          JOIN Reports AS r
	            ON r.CategoryId = c.Id
          GROUP BY d.[Name],
                   c.[Name]) AS ReportCounts
ORDER BY [Department Name],
         [Category Name],
		 [Percentage]