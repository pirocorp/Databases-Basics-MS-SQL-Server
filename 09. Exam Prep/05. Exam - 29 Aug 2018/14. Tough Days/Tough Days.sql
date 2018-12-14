    SELECT e.FirstName + ' ' + e.LastName AS [Full Name],
    	   DATENAME(WEEKDAY, s.CheckIn) AS [Day of week]
      FROM Employees AS e
 LEFT JOIN Orders AS o ON o.EmployeeId = e.Id
INNER JOIN Shifts AS s ON s.EmployeeId = e.Id
     WHERE o.Id IS NULL 
	   AND DATEDIFF(HOUR, s.CheckIn, s.CheckOut) > 12
  ORDER BY e.Id