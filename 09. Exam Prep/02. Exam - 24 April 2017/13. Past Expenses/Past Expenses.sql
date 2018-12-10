   SELECT j.JobId,
          ISNULL(SUM(p.Price * pn.Quantity), 0) AS Total
     FROM Jobs AS j
LEFT JOIN PartsNeeded AS pn
       ON pn.JobId = j.JobId
LEFT JOIN Parts AS p
       ON pn.PartId = p.PartId
    WHERE [Status] = 'Finished'
 GROUP BY j.JobId 
 ORDER BY Total DESC,
          j.JobId ASC


   SELECT j.JobId,
          ISNULL(SUM(p.Price * op.Quantity), 0) AS Total 
     FROM Jobs AS j
LEFT JOIN Orders AS o
       ON o.JobId = j.JobId
LEFT JOIN OrderParts AS op
       ON op.OrderId = o.OrderId
LEFT JOIN Parts AS p
       ON p.PartId = op.PartId
    WHERE [Status] = 'Finished'
 GROUP BY j.JobId 
 ORDER BY Total DESC,
          j.JobId ASC
  