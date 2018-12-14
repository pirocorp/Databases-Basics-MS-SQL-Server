SELECT DISTINCT e.Id,
     	        CONCAT(e.FirstName, ' ', e.LastName) AS [Full Name]
           FROM Employees AS e
     INNER JOIN Shifts AS s ON s.EmployeeId = e.Id
          WHERE DATEDIFF(HOUR, s.CheckIn, s.CheckOut) < 4
     ORDER BY e.Id