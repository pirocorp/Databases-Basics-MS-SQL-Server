  SELECT i.[Name] AS [Item],
         i.Price,
  	   i.MinLevel,
  	   gt.[Name] AS [Forbidden Game Type]
    FROM GameTypeForbiddenItems AS fi
    RIGHT JOIN Items AS i 
      ON i.Id = fi.ItemId
    LEFT JOIN GameTypes AS gt
      ON gt.Id = fi.GameTypeId
ORDER BY gt.[Name] DESC,
         i.[Name]