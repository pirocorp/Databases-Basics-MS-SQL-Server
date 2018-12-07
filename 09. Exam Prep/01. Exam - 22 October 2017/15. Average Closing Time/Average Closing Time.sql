   SELECT d.[Name] AS [Department Name],
		  ISNULL(CONVERT(NVARCHAR(20), AVG(DATEDIFF(DAY, r.OpenDate, r.CloseDate))), 'no info') AS [Average Duration]
     FROM Departments AS d
     JOIN Categories AS c
       ON c.DepartmentId = d.Id
     JOIN Reports AS r
       ON r.CategoryId = c.Id
 GROUP BY d.[Name]
 ORDER BY d.[Name]