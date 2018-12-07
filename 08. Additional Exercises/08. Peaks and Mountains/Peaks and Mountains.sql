  SELECT p.PeakName,
         m.MountainRange AS [Mountain],
		 p.Elevation
    FROM Peaks as p
	JOIN Mountains AS m
	  ON m.Id = p.MountainId
ORDER BY Elevation DESC,
         p.PeakName
    