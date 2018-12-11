WITH CTE_OrdersByAgeGroup AS (
SELECT 
	   CASE  
           WHEN DATEPART(YEAR, c.BirthDate) BETWEEN 1970 AND 1979 THEN '70''s'  
           WHEN DATEPART(YEAR, c.BirthDate) BETWEEN 1980 AND 1989 THEN '80''s' 
           WHEN DATEPART(YEAR, c.BirthDate) BETWEEN 1990 AND 1999 THEN '90''s' 
           ELSE 'Others'  
        END AS AgeGroup,         
       ISNULL(o.Bill, 0) AS Revenue,
	   ISNULL(o.TotalMileage, 0) AS Mileage
  FROM Clients AS c
  JOIN Orders AS o ON o.ClientId = c.Id 
 WHERE ReturnDate IS NOT NULL)

  SELECT AgeGroup,
         SUM(Revenue) AS Revenue,
		 AVG(Mileage) AS AverageMileage
    FROM CTE_OrdersByAgeGroup
GROUP BY AgeGroup
ORDER BY AgeGroup ASC