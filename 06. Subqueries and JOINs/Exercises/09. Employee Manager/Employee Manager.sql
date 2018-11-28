   SELECT e.EmployeeID,
          e.FirstName,
		  m.EmployeeID AS ManagerID,
          m.FirstName AS ManagerName
     FROM Employees AS e
LEFT JOIN Employees AS m
       ON m.EmployeeID = e.ManagerID
	WHERE m.EmployeeID IN (3, 7)
 ORDER BY EmployeeID ASC
       GO