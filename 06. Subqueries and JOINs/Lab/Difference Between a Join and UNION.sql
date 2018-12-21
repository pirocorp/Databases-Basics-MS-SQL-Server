--In simple terms, joins combine data into new columns.  
--If two tables are joined together, then the data from the first table 
--is shown in one set of column alongside the second table’s column in the same row.
--Each row in the result contains columns from BOTH table A and B.  
--Rows are created when columns from one table match columns from another.  
--This match is called the join condition.
--This makes joins really great for looking up values and including them in results.  
--This is usually the result of denormalizing (reversing normalization) and involves 
--using the foreign key in one table to look up column values by using the primary key 
--in another.
USE AdventureWorks2012
GO

SELECT   Employee.NationalIDNumber,
         Person.FirstName,
         Person.LastName,
         Employee.JobTitle
FROM     HumanResources.Employee
         INNER JOIN
         Person.Person
         ON HumanResources.Employee.BusinessEntityID = person.BusinessEntityID
ORDER BY person.LastName;

--Unions combine data into new rows.  If two tables are “unioned” together, 
--then the data from the first table is in one set of rows, and the data from 
--the second table in another set.  The rows are in the same result.
--Unions are typically used where you have two results whose rows you want to 
--include in the same result

--In order to union two table there are a couple of requirements:
--The number of columns must be the same for both select statements.
--The columns, in order, must be of the same data type.

SELECT C.Name
FROM   Production.ProductCategory AS C
UNION ALL
SELECT S.Name
FROM   Production.ProductSubcategory AS S

--When rows are combined duplicate rows are eliminated.  If you want to keep all
--rows from both select statement’s results use the ALL keyword