USE [Geography]
 GO

  SELECT MountainRange, 
         PeakName, 
  	     Elevation
    FROM Peaks
    JOIN Mountains ON Peaks.MountainId = Mountains.Id
   WHERE MountainId = (
                       SELECT Id 
                         FROM Mountains
                        WHERE MountainRange = 'Rila'
					   )
ORDER BY Elevation DESC
      GO