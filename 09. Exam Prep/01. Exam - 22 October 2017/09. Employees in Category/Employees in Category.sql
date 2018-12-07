   SELECT c.[Name] AS [CategoryName],
          COUNT(e.Id) AS [Employees Number]
     FROM Categories AS c
LEFT JOIN Departments AS d
       ON d.Id = c.DepartmentId
LEFT JOIN Employees AS e
       ON e.DepartmentId = d.Id
 GROUP BY c.Id, 
          c.[Name]
 ORDER BY [CategoryName]