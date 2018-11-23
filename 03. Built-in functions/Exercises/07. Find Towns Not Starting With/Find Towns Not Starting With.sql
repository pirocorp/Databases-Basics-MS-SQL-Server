  --Can be don with [^RBD]%
  SELECT *       
    FROM Towns
   WHERE LEFT([Name], 1) NOT IN ('R', 'B', 'D')
ORDER BY [Name]