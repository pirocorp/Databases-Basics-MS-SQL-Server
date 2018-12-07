SELECT DISTINCT c.[Name] AS [Category Name]
           FROM Reports AS r
           JOIN Users AS u
             ON u.Id = r.UserId
           JOIN Categories AS c
             ON c.Id = r.CategoryId
          WHERE DAY(r.OpenDate) = DAY(u.BirthDate)
            AND MONTH(r.OpenDate) = MONTH(u.BirthDate)
       ORDER BY [Category Name]