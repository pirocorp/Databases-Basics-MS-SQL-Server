SELECT t.[Name] AS TownName,
       o.[Name] AS OfficeName,
       o.ParkingPlaces
  FROM Offices AS o
  JOIN Towns AS t
    ON t.Id = o.TownId
 WHERE ParkingPlaces > 25
ORDER BY TownName ASC,
         o.Id ASC