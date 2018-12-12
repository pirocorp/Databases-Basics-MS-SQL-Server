WITH CTE_ProductsByIngredientDistributor AS(
	  SELECT p.Id,
	         p.[Name] AS ProductName,
	         AVG(f.Rate) AS ProductAverageRate,
	  	     d.[Name] AS DistributorName,
	  	     dc.[Name] AS DistributorCountry
	    FROM Products AS p
	    JOIN Feedbacks AS f ON p.Id = f.ProductId
	    JOIN ProductsIngredients AS pin ON pin.ProductId = p.Id
	    JOIN Ingredients AS i ON i.Id = pin.IngredientId
	    JOIN Distributors AS d ON d.Id = i.DistributorId
	    JOIN Countries AS dc ON dc.Id = d.CountryId
	GROUP BY p.Id, p.[Name], d.[Name], dc.[Name])

SELECT ProductName,
       ProductAverageRate,
	   DistributorName,
	   DistributorCountry
  FROM CTE_ProductsByIngredientDistributor
 WHERE Id IN (  SELECT id          
                  FROM CTE_ProductsByIngredientDistributor
              GROUP BY id
                HAVING COUNT(DISTINCT DistributorName) = 1)		 