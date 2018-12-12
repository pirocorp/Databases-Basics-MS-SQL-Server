CREATE OR ALTER VIEW v_UserWithCountries AS
SELECT CONCAT(cu.FirstName, ' ', cu.LastName) AS CustomerName,
       cu.Age,
	   cu.Gender,
	   co.[Name] AS CountryName
  FROM Customers AS cu
  JOIN Countries AS co ON co.Id = cu.CountryId

  SELECT TOP 5 *
  FROM v_UserWithCountries
 ORDER BY Age
