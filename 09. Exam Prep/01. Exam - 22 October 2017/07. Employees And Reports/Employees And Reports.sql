  SELECT FirstName,
         LastName,
  	     [Description],
  	     FORMAT(OpenDate, 'yyyy-MM-dd') AS [OpenDate]
    FROM Employees AS e
    JOIN Reports AS r
      ON e.Id = r.EmployeeId
   WHERE EmployeeId IS NOT NULL
ORDER BY EmployeeId ASC,
         [OpenDate] ASC,
		 r.Id ASC