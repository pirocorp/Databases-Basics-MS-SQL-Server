  SELECT Manufacturer,
         AVG(Consumption) AS [AverageConsumption]
    FROM Models
   WHERE Id IN (SELECT TOP 7 m.Id
                      FROM Orders AS o
                      JOIN Vehicles AS v ON v.Id = o.VehicleId
                      JOIN Models AS m ON m.Id = v.ModelId
                  GROUP BY m.Id         
                  ORDER BY COUNT(o.id)DESC)
GROUP BY Manufacturer
  HAVING AVG(Consumption) BETWEEN 5 AND 15
ORDER BY Manufacturer ASC,
         AverageConsumption ASC