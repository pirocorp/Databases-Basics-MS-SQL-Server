   SELECT CONCAT(m.FirstName, ' ', m.LastName) AS Mechanic,
          v.[Name] AS Vendor,
		  SUM(op.Quantity) AS Parts,
		  CONCAT(CONVERT(INT, FLOOR(SUM(op.Quantity) * 100.00 / SUM(ISNULL(SUM(op.Quantity), 0)) OVER(PARTITION BY m.MechanicId))), '%') AS [Preference]
     FROM OrderParts AS op
 JOIN Parts AS p ON p.PartId = op.PartId
 JOIN Vendors AS v ON v.VendorId = p.VendorId
 JOIN Orders AS o ON o.OrderId = op.OrderId
 JOIN Jobs AS j on j.JobId = o.JobId
 JOIN Mechanics AS m ON m.MechanicId = j.MechanicId
 GROUP BY m.MechanicId,
          m.FirstName,
		  m.LastName,
		  v.[Name]
 ORDER BY Mechanic ASC,
          Parts DESC,
		  Vendor ASC


WITH CTE_Parts(MechanicId, Vendor, TotalParts) AS (
  SELECT m.MechanicId,
  	     v.[Name] AS [Vendor],
  	     SUM(op.Quantity) AS [TotalParts]
    FROM Mechanics AS m
    JOIN Jobs AS j ON j.MechanicId = m.MechanicId
    JOIN Orders AS o ON o.JobId = j.JobId
    JOIN OrderParts AS op ON op.OrderId = o.OrderId
    JOIN Parts AS p ON p.PartId = op.PartId
    JOIN Vendors AS v ON v.VendorId = p.VendorId
GROUP BY m.MechanicId,
	     v.[Name])

SELECT CONCAT(m.FirstName, ' ', m.LastName) AS [Mechanic],
       cp.Vendor,
	   cp.TotalParts,
	   CONCAT(CONVERT(INT, cp.TotalParts * 100.00 / (SELECT SUM(TotalParts) FROM CTE_Parts WHERE MechanicId = m.MechanicId)), '%') AS Preference
  FROM CTE_Parts AS cp
  JOIN Mechanics AS m ON m.MechanicId = cp.MechanicId
ORDER BY Mechanic,
         TotalParts DESC,
		 Vendor