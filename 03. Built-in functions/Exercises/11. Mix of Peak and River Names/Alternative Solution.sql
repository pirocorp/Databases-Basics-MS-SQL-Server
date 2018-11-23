USE [Geography]
 GO
   
  SELECT PeakName, 
		 RiverName,
		 LOWER(CONCAT(PeakName, SUBSTRING(RiverName, 2, LEN(RiverName)))) AS [Mix]
    FROM Peaks, 
		 Rivers
   WHERE RIGHT(Peaks.PeakName, 1) = LEFT(Rivers.RiverName, 1)
ORDER BY Mix
	  GO