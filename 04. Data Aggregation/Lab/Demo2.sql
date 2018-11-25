--Ranking Functions

--Eliminate duplicate rows
--Local temporary table name is stared with hash ("#") sign. Local temp tables are only available to the 
--current connection for the user; and they are automatically deleted when the user disconnects from instances.
--Global Temporary tables name starts with a double hash ("##"). Once this table has been created by a connection, 
--like a permanent table it is then available to any user by any connection. It can only be deleted once all connections have been closed.
DROP TABLE IF EXISTS #Duplicates
  GO

 CREATE TABLE #Duplicates(Col1 INT, Col2 CHAR(1));
 INSERT INTO #Duplicates(Col1, Col2) 
VALUES  (1,'A'),(2,'B'),(2,'B'),(2,'B'),
	    (3,'C'),(4,'D'),(4,'D'),(5,'E'),
	    (5,'E'),(5,'E');
	GO

SELECT * 
  FROM #Duplicates;
    GO

--Adding ROW_NUMBER and partitioning by each column will restart the row numbers for each unique set of rows. 
--You can identify the unique rows by finding those with a row number equal to one. 	
SELECT Col1, Col2, 
	ROW_NUMBER() OVER(PARTITION BY Col1, Col2 ORDER BY Col1) AS RowNum
FROM #Duplicates;
  GO

--Now, all you have to do is to delete any rows that have a row number greater than one. 
--The problem is that you cannot add window functions to the WHERE clause.
--The way around this problem is to separate the logic using a common table expression (CTE). You can then delete the rows right from the CTE.
  WITH Dupes(Column1, Column2, [Row Number]) AS (
  	   SELECT Col1, Col2, 
  	   	      ROW_NUMBER() OVER(PARTITION BY Col1, Col2 ORDER BY Col1) AS RowNum
  	     FROM #Duplicates)
DELETE Dupes 
 WHERE [Row Number] <> 1;
    GO

SELECT * 
  FROM #Duplicates;
    GO

--To see the difference between ROW_NUMBER, RANK, and DENSE_RANK, run this query: 
--The ORDER BY for each OVER clause is OrderDate which is not unique. 
--This customer placed two orders on 2013-10-24. ROW_NUMBER just continued assigning numbers 
--and didn’t do anything different even though there is a duplicate date. RANK assigned 6 to both rows
--and then caught up to ROW_NUMBER with an 8 on the next row. DENSE_RANK also assigned 6 to the two rows 
--but assigned 7 to the following row.
--Two explain the difference, think of ROW_NUMBER as positional. RANK is both positional and logical. 
--Those two rows are ranked logically the same, but the next row is ranked by the position in the set. 
--DENSE_RANK ranks them logically. Order 2013-11-04 is the 7th unique date.	
USE Adventureworks2017
 GO

SELECT SalesOrderID, OrderDate, CustomerID, 
	   ROW_NUMBER() OVER(ORDER BY OrderDate) As [ROW NUMBER],
	         RANK() OVER(ORDER BY OrderDate) As [RANK],
	   DENSE_RANK() OVER(ORDER BY OrderDate) As [DENSE RANK]
  FROM Sales.SalesOrderHeader
 WHERE CustomerID = 11330;
    GO

--The final function in this group is called NTILE. It assigns bucket numbers to the rows 
--instead of row numbers or ranks. Here is an example:
--NTILE has a parameter, in this case 4, which is the number of buckets you want to see in the results. 
--The ORDER BY is applied to the sum of the sales. The rows with the lowest 25% are assigned 1, 
--the rows with the highest 25% are assigned 4. Finally, the results of NTILE are multiplied by 1000 
--to come up with the bonus amount. 
--Since 14 cannot be evenly divided by 4, an extra row goes into each of the first two buckets. 	
  SELECT SP.FirstName, SP.LastName,
	     SUM(SOH.TotalDue) AS TotalSales, 
	     NTILE(4) OVER(ORDER BY SUM(SOH.TotalDue)) * 1000 AS Bonus
    FROM [Sales].[vSalesPerson] SP 
    JOIN Sales.SalesOrderHeader SOH ON SP.BusinessEntityID = SOH.SalesPersonID 
   WHERE SOH.OrderDate >= '2012-01-01' AND SOH.OrderDate < '2013-01-01'
GROUP BY FirstName, LastName;
	  GO

--Window Aggregates

--Say, for example you would like to display all the customer orders along with the subtotal for each customer. 
--By adding a SUM using the OVER clause, you can accomplish this very easily: 	
SELECT CustomerID, 
       OrderDate, 
       SalesOrderID, 
       TotalDue, 
	   SUM(TotalDue) OVER(PARTITION BY CustomerID) AS SubTotal 
  FROM Sales.SalesOrderHeader;
    GO

--By adding the PARTITION BY, a subtotal is calculated for each customer. Any aggregate function can be used with ORDER BY Aggregate by the given order
SELECT CustomerID, 
       OrderDate, 
       SalesOrderID, 
       TotalDue,
	   SUM(TotalDue) OVER(PARTITION BY CustomerID ORDER BY SalesOrderID) AS [Running Total By Customer],
	   SUM(TotalDue) OVER(PARTITION BY CustomerID) AS [Customer Total],  
	   SUM(TotalDue) OVER(ORDER BY CustomerID, SalesOrderId) AS [Sub Total] 
  FROM Sales.SalesOrderHeader;
    GO

--Two of the functions allow you to pull columns or expressions from a row before (LAG) or after (LEAD) the current row.
--LAG and LEAD require an argument – the column or expression you want to return. 
--By default, LAG returns the value from the previous row, and LEAD returns the value from the following row. 
  SELECT CustomerID, OrderDate, SalesOrderID, 
	     LAG(SalesOrderID) OVER(PARTITION BY CustomerID ORDER BY SalesOrderID) AS PrevOrder
    FROM Sales.SalesOrderHeader
ORDER BY CustomerID;
      GO

--With defaulth value LAG(expression, offset, default value) 	
SELECT CustomerID, OrderDate, SalesOrderID, 
	   LAG(SalesOrderID, 2, 0) OVER(PARTITION BY CustomerID ORDER BY SalesOrderID) AS Back2Orders
  FROM Sales.SalesOrderHeader
    GO

--FIRST_VALUE and LAST_VALUE can be used to find a value from the very first row or very last row of the partition. Be sure to specify the frame
--FirstOrder returns first order for every CustomerID
SELECT CustomerID, 
	   OrderDate, 
	   SalesOrderID, 
  	   FIRST_VALUE(SalesOrderID) OVER(PARTITION BY CustomerID 
	                                      ORDER BY SalesOrderID
  										      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS FirstOrder --This specifies frame
  FROM Sales.SalesOrderHeader
    GO

--LEAD (expression [, offset], [ default ] ) OVER ( [ partition_by_clause ] order_by_clause ) []-optional arguments
--Accesses data from a subsequent row in the same result set without the use of a self-join
--LEAD provides access to a row at a given physical offset that follows the current row. 
--Use this analytic function in a SELECT statement to compare values in the current row with values in a following row. 
--A. Compare values between years
USE AdventureWorks2012;  
GO
  
SELECT BusinessEntityID, 
       YEAR(QuotaDate) AS SalesYear, 
	   SalesQuota AS CurrentQuota,   
       LEAD(SalesQuota, 1,0) OVER (ORDER BY YEAR(QuotaDate)) AS NextQuota  
  FROM Sales.SalesPersonQuotaHistory  
 WHERE BusinessEntityID = 275 and YEAR(QuotaDate) IN ('2013','2014')
    GO

--B. Compare values within partitions
--The PARTITION BY clause is specified to partition the rows in the result set by sales territory. 
  SELECT TerritoryName, 
	     BusinessEntityID, 
		 SalesYTD,   
         LEAD (SalesYTD, 1, 0) OVER (PARTITION BY TerritoryName ORDER BY SalesYTD DESC) AS NextRepSales  
    FROM Sales.vSalesPerson  
   WHERE TerritoryName IN (N'Northwest', N'Canada')   
ORDER BY TerritoryName
      GO
