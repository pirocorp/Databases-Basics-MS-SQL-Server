--A subquery-also referred to as an inner query or inner select-is a SELECT statement embedded 
--within a data manipulation language (DML) statement or nested within another subquery.
--You can use subqueries in SELECT, INSERT, UPDATE, and DELETE 
--statements wherever expressions are allowed. For instance, 
--you can use a subquery as one of the column expressions in a 
--SELECT list or as a table expression in the FROM clause.
--You must enclose a subquery in parenthesis.
--A subquery must include a SELECT clause and a FROM clause.
--A subquery can include optional WHERE, GROUP BY, and HAVING clauses.
--A subquery cannot include COMPUTE or FOR BROWSE clauses.
--You can include an ORDER BY clause only when a TOP clause is included.
--You can nest subqueries up to 32 levels.
--Adding Subqueries to the SELECT Clause
USE AdventureWorks2017
 GO
 	
SELECT SalesOrderNumber,
       SubTotal,
       OrderDate,
       (
         SELECT SUM(OrderQty)
           FROM Sales.SalesOrderDetail
          WHERE SalesOrderID = 43659
       ) AS TotalQuantity
  FROM Sales.SalesOrderHeader
 WHERE SalesOrderID = 43659;
    GO

--You can use a subquery anywhere in a SQL Statement where an expression is allowed. 
--use it as part of a CASE statement
SELECT SalesOrderNumber,
       SubTotal,
       OrderDate,
       CASE WHEN
         (
           SELECT SUM(LineTotal)
           FROM Sales.SalesOrderDetail
           WHERE SalesOrderID = 43660
         ) =  SubTotal THEN 'balanced' 
         ELSE 'not balanced'
       END AS LineTotals
  FROM Sales.SalesOrderHeader
 WHERE SalesOrderID = 43660;
    GO

--A correlated subquery, also known as a repeating subquery, is one that depends on the outer query 
--for specific values. This is particularly important if your outer query returns multiple rows.
--As a result, the subquery is executed for each row returned by the outer query. 
SELECT SalesOrderNumber,
       SubTotal,
       OrderDate,
       CASE WHEN
         (
           SELECT SUM(LineTotal)
           FROM Sales.SalesOrderDetail AS d
           WHERE d.SalesOrderID = h.SalesOrderID
         ) =  h.SubTotal THEN 'balanced' 
         ELSE 'not balanced'
       END AS LineTotals
  FROM Sales.SalesOrderHeader AS h;
    GO

--Adding Subqueries to the FROM Clause
--A derived table is useful when you want to work with a subset of data from one or more 
--tables without needing to create a view or temporary table.
--INNER JOIN WHEN JOIN OUTHER TABLE to derived table?!
--The first thing to notice is that the subquery returns a derived table that includes 
--two columns and multiple rows. Because the subquery returns a table, I can join that table, 
--which I’ve named ps, to the results from the Product table (p). As the join demonstrates, 
--you treat a subquery used in the FROM clause just as you would treat any table. 
SELECT p.ProductID,
       p.Name AS ProductName,
       p.ProductSubcategoryID AS SubcategoryID,
       ps.Name AS SubcategoryName
  FROM Production.Product p INNER JOIN
       (
         SELECT ProductSubcategoryID, 
		        [Name] 
           FROM Production.ProductSubcategory
          WHERE [Name] LIKE '%bikes%'
       ) AS ps
    ON p.ProductSubcategoryID = ps.ProductSubcategoryID; 
	GO

--Adding Subqueries to the WHERE Clause
SELECT BusinessEntityID,
       FirstName,
       LastName
  FROM Person.Person
 WHERE BusinessEntityID =
       (
         SELECT BusinessEntityID
         FROM HumanResources.Employee
         WHERE NationalIDNumber = '895209680'
       );
	GO

--SalesQuota figure is greater than the average
SELECT p.BusinessEntityID,
       p.FirstName,
       p.LastName,
       s.SalesQuota
  FROM Person.Person p INNER JOIN
       Sales.SalesPerson s
       ON p.BusinessEntityID = s.BusinessEntityID
 WHERE s.SalesQuota IS NOT NULL AND
       s.SalesQuota >
       (
         SELECT AVG(SalesQuota)
         FROM Sales.SalesPerson
       );
    GO

--SalesQuota value for each row returned must be greater than ANY of the 
--values returned by the subquery 	
SELECT p.BusinessEntityID,
       p.FirstName,
       p.LastName,
       s.SalesQuota
  FROM Person.Person p INNER JOIN
       Sales.SalesPerson s
       ON p.BusinessEntityID = s.BusinessEntityID
 WHERE s.SalesQuota IS NOT NULL AND
       s.SalesQuota > ANY
       (
         SELECT SalesQuota
         FROM Sales.SalesPerson
       );
	GO

--SalesQuota value for each row returned must be greater than ALL of the 
--values returned by the subquery	
SELECT p.BusinessEntityID,
       p.FirstName,
       p.LastName,
       s.SalesQuota
  FROM Person.Person p INNER JOIN
       Sales.SalesPerson s
       ON p.BusinessEntityID = s.BusinessEntityID
 WHERE s.SalesQuota IS NOT NULL AND
       s.SalesQuota > ALL
       (
         SELECT SalesQuota
         FROM Sales.SalesPerson
       );
	GO

--The BusinessEntityID value from the outer query is compared to the 
--list of ID values returned by the subquery.
--If the BusinessEntityID value matches one of the values in the subquery list, 
--the row is included in the outer query’s results
SELECT BusinessEntityID,
       FirstName,
       LastName
  FROM Person.Person
 WHERE BusinessEntityID IN
       (
         SELECT BusinessEntityID
         FROM HumanResources.Employee
         WHERE JobTitle = 'Sales Representative'
       );
	GO

--return only those rows whose BusinessEntityID value does not match 
--any values in the list returned by the subquery
SELECT BusinessEntityID,
       FirstName,
       LastName
  FROM Person.Person
 WHERE BusinessEntityID NOT IN
       (
         SELECT BusinessEntityID
         FROM HumanResources.Employee
         WHERE JobTitle = 'Sales Representative'
       );
	GO

--Correlated subquery to check the name of each product’s 
--subcategory to determine whether that name is Mountain Bikes
--the returned rows are part of the Mountain Bikes subcategory
SELECT ProductID, 
       [Name] AS ProductName 
  FROM Production.Product AS p 
 WHERE EXISTS ( 
               SELECT * 
			     FROM Production.ProductSubcategory AS s 
				WHERE p.ProductSubcategoryID = s.ProductSubcategoryID AND s.[Name] = 'Mountain Bikes' 
			  );
	GO

--the returned rows are NOT part of the Mountain Bikes subcategory
SELECT ProductID, 
       [Name] AS ProductName 
  FROM Production.Product AS p 
 WHERE NOT EXISTS ( 
               SELECT * 
			     FROM Production.ProductSubcategory AS s 
				WHERE p.ProductSubcategoryID = s.ProductSubcategoryID AND s.[Name] = 'Mountain Bikes' 
			  );
	GO

--Simple Subquery to Calculate Average
--Subqueries are enclosed in parenthesis.
--When subqueries are used in a SELECT statement they can only return one value. 
--This should make sense, simply selecting a column returns one value for a row, 
--and we need to follow the same pattern.
--In general, the subquery is run only once for the entire query, and its result reused. 
--This is because, the query result does not vary for each row returned.
--It is important to use aliases for the column names to improve readability.
SELECT SalesOrderID,
       LineTotal,
       (
	    SELECT AVG(LineTotal)
        FROM Sales.SalesOrderDetail
	   ) AS AverageLineTotal
  FROM Sales.SalesOrderDetail;
    GO

--Simple Subquery in Expression
SELECT SalesOrderID,
       LineTotal,
       (
	    SELECT AVG(LineTotal)
          FROM   Sales.SalesOrderDetail
	   ) AS AverageLineTotal,
       LineTotal - (
	                SELECT AVG(LineTotal)
                    FROM   Sales.SalesOrderDetail
				   ) AS Variance
  FROM Sales.SalesOrderDetail
    GO

--Correlated Queries called synchronized queries
--Correlated Subquery Example
--You can see I used column aliases to help make the query results easier to read.
--I also used a table alias, SOD, for the outer query. This makes it possible to 
--use the outer query’s values in the subquery.  Otherwise, the query isn’t correlated!
--Using the table aliases make it unambiguous which columns are from each table.
SELECT SalesOrderID,
       SalesOrderDetailID,
       LineTotal,
       (
	    SELECT AVG(LineTotal)
          FROM Sales.SalesOrderDetail AS ISOD
         WHERE ISOD.SalesOrderID = SOD.SalesOrderID
	   ) AS AverageLineTotal
  FROM Sales.SalesOrderDetail AS SOD
    GO

--Correlated Subquery with a Different Table
--The subquery is selecting data from a different table than the outer query.
--I used table and column aliases to make it easier to read the SQL and results.
--Be sure to double check your WHERE clause! If you forget to include the table name 
--or aliases in the subquery WHERE clause, the query won’t be correlated.
SELECT SalesOrderID,
       OrderDate,
       TotalDue,
       (
	    SELECT COUNT(SalesOrderDetailID)
          FROM Sales.SalesOrderDetail AS SOD
         WHERE SOD.SalesOrderID = SOH.SalesOrderID
	   ) AS LineCount
  FROM Sales.SalesOrderHeader AS SOH
    GO

--Correlated Subqueries versus Inner Joins
--SUBQUERY
SELECT SalesOrderID,
       OrderDate,
       TotalDue,
       (
	    SELECT COUNT(SalesOrderDetailID)
          FROM Sales.SalesOrderDetail AS SOD
         WHERE SOD.SalesOrderID = SOH.SalesOrderID
	   ) as LineCount
  FROM Sales.SalesOrderHeader AS SOH
    GO

--INNER JOIN
  SELECT SOH.SalesOrderID,
         OrderDate,
         TotalDue,
         COUNT(SOD.SalesOrderDetailID) as LineCount
    FROM Sales.SalesOrderHeader AS SOH
         INNER JOIN Sales.SalesOrderDetail AS SOD
         ON SOD.SalesOrderID = SOH.SalesOrderID
GROUP BY SOH.SalesOrderID, OrderDate, TotalDue
      GO