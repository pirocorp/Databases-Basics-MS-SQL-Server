SELECT DISTINCT e.Id,
     	        e.FirstName,
     	        e.LastName
           FROM Employees AS e
     INNER JOIN Orders AS o ON o.EmployeeId = e.Id
       ORDER BY e.Id 