  SELECT CONCAT(m.Manufacturer, ' - ', m.Model) AS Vehicle,
  	     CASE
  			WHEN (SELECT TOP 1 id FROM Orders WHERE VehicleId = v.Id) IS NULL THEN 'home'
  		  	WHEN (SELECT TOP 1 ReturnDate FROM Orders WHERE VehicleId = v.Id ORDER BY CollectionDate DESC) IS NULL THEN 'on a rent'
  		  	ELSE (  SELECT TOP 1 CONCAT(t.[Name], ' - ', ro.[Name])
                          FROM Orders AS o
                      	  JOIN Offices AS ro ON ro.Id = ReturnOfficeId
                      	  JOIN Towns AS t ON t.Id = ro.TownId
                         WHERE VehicleId = v.Id
                      ORDER BY CollectionDate DESC)
  	     END AS [Location]
    FROM Vehicles AS v
   JOIN Models AS m ON m.Id = v.ModelId
   JOIN Offices AS ho ON ho.Id = v.OfficeId
   JOIN Towns AS ht ON ht.Id = ho.TownId
ORDER BY Vehicle,
         v.Id