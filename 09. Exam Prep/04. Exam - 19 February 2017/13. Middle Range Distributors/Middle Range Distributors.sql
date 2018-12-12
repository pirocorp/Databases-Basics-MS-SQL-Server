SELECT d.[Name] AS DistributorName,
       i.[Name] AS IngredientName,
	   p.[Name] AS ProductName,
	   (  SELECT AVG(Rate)
            FROM Feedbacks AS f
            JOIN Products AS inp ON inp.Id = f.ProductId
           WHERE inp.Id = p.Id) AS AverageRate
  FROM ProductsIngredients AS pin
  JOIN Products AS p ON p.Id = pin.ProductId
  JOIN Ingredients AS i ON i.Id = pin.IngredientId
  JOIN Distributors AS d ON d.Id = i.DistributorId
 WHERE ProductId IN (  SELECT inp.id
                         FROM Feedbacks AS f
                         JOIN Products AS inp ON inp.Id = f.ProductId
                     GROUP BY inp.Id
                       HAVING AVG(Rate) BETWEEN 5 AND 8)
ORDER BY DistributorName ASC,
         IngredientName ASC,
		 ProductName ASC