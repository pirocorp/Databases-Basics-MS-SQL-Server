  SELECT m.Model,
         m.Seats,
  	     v.Mileage 
    FROM Vehicles AS v
    JOIN Models AS m ON m.Id = v.ModelId
   WHERE v.Id NOT IN (SELECT VehicleId FROM Orders WHERE ReturnDate IS NULL)
ORDER BY v.Mileage ASC,
         m.Seats DESC,
		 m.Id ASC
