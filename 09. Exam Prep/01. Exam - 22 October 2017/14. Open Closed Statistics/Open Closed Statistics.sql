  SELECT [Name],
         CONCAT(COUNT(Closed), '/', COUNT([Open])) AS [Closed Open Reports]
    FROM (SELECT e.Id,
                 CONCAT(e.FirstName, ' ', LastName) AS [Name],
                 CASE  
     				  WHEN YEAR(r.CloseDate) != 2016 THEN NULL  
     				  ELSE r.CloseDate  
                  END AS [Closed],
     	         CASE   
     	    	      WHEN YEAR(r.OpenDate) != 2016 THEN NULL  
     	    		  ELSE r.OpenDate  
                  END AS [Open]
            FROM Employees AS e
            JOIN Reports AS r
              ON r.EmployeeId = e.Id) AS OpenClosedProjects
GROUP BY Id, [Name]
  HAVING COUNT(Closed) > 0 
      OR COUNT([Open]) > 0
ORDER BY [Name]
