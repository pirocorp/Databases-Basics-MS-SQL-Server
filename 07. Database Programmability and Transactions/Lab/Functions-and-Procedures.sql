--Types of User-Defined Functions

--Restrictions
--1.You cannot create a temporary function in the same way as you would a 
--temporary table or procedure.(with the # or ## prefix)
--2.You cannot create a function in another database such as TempDB, 
--though you can access one in another database.
--3.You cannot use SET statements in a user-defined function to change the 
--current session handling, because of the danger of producing a side-effect.
--4.User-defined functions cannot be used to perform any actions that modify 
--the database state, such as writing to a table or even using an OUTPUT INTO 
--clause that has a table as its target.
--5.User-defined functions cannot return a result set, only a single table data type. 
--Stored procedure, in contrast, can be used to return one or more result sets.
--6.A UDF has very restricted error handling. It supports neither RAISERROR nor TRY…CATCH. 
--You can’t get at the @ERROR.
--7.You cannot call a stored procedure from within a UDF, but you can call an 
--extended stored procedure.
--8.User-defined functions cannot make use of dynamic SQL or temporary tables.
--9.Several service broker statements cannot be used in functions.
--10.Side-affecting operators such as NEWID(), RAND(), TEXTPTR or NEWSEQUENTIALID() 
--aren’t allowed in functions though, for some reason, GETDATE() or HOST_ID() is, 
--though it makes the function non-deterministic. You can get a random number or 
--any other banned system function by creating a view that calls the system function 
--and then calling the view from within the user-defined function. 
--The resulting function won’t be deterministic, though.

--Only the following statements are allowed within multi-statement functions
--1.Assignment statements.
--2.Control-of-Flow statements except for TRY…CATCH statements.
--3.DECLARE statements that define local data variables and local cursors.
--4.SELECT statements that contain select lists with expressions that assign values to 
--local variables.
--5.Cursor operations referencing local cursors that are declared, opened, closed, 
--and deallocated in the function. Only FETCH statements that assign values to local 
--variables using the INTO clause are allowed; FETCH statements that return data to 
--the client are not allowed.
--6.INSERT, UPDATE, and DELETE statements only if they modify local table variables.
--7.EXECUTE statements calling extended stored procedures, but these cannot return 
--result sets.

--Things that can be done with functions but are to be avoided where possible.
--1.If computed columns have scalar functions in them they’ll make queries, 
--index rebuilds and make some DBCC checks go serial. They will slow any updates 
--that trigger a recalculation.
--2.Any multi-statement function can be a performance overhead
--3.Multi-statement table-value functions can cause excessive recompiles if used as a 
--table source
--4.Any multi-statement table-value function used directly, within a SQL expression, 
--as a table source involved in a join will be slow due to getting a poor execution plan
--5.Using a scalar function in a WHERE clause or an ON clause for anything other than a 
--small quantity of data should be avoided


--Scalar functions (like SQRT(…)).
--Similar to the built-in functions
--Return a single value
CREATE FUNCTION udf_ProjectDurationWeeks (@StartDate DATETIME, @EndDate DATETIME)
RETURNS INT
AS
BEGIN
  DECLARE @projectWeeks INT;
  IF(@EndDate IS NULL)
  BEGIN
    SET @EndDate = GETDATE()
  END
  SET @projectWeeks = DATEDIFF(WEEK, @StartDate, @EndDate)
  RETURN @projectWeeks;
END
 GO

--Functions are called using schemaName.functionName
SELECT [ProjectID],
       [StartDate],
       [EndDate],
       dbo.udf_ProjectDurationWeeks([StartDate],[EndDate])
    AS ProjectWeeks
  FROM [SoftUni].[dbo].[Projects]
    GO

--Scalar-valued functions can be executed by using the EXECUTE statement. 
--you can leave out the schema name in the function name, and it will look 
--in the dbo schema followed by the users default schema.  	
CREATE FUNCTION dbo.NthDayOfWeekOfMonth (
  @TheYear CHAR(4), --the year as four characters (e.g. '2014')
  @TheMonth CHAR(3), --in english (Sorry to our EU collegues) e.g. Jun, Jul, Aug
  @TheDayOfWeek CHAR(3)='Sun', -- one of Mon, Tue, Wed, Thu, Fri, Sat, Sun
  @Nth INT=1) --1 for the first date, 2 for the second occurence, 3 for the third
  RETURNS DATETIME
  WITH EXECUTE AS CALLER
  AS
  BEGIN
  RETURN DATEADD(MONTH, DATEDIFF(MONTH, 0, CONVERT(DATE,'1 '+@TheMonth+' '+@TheYear,113)), 0)+ (7*@Nth)-1
          -(DATEPART (WEEKDAY, DATEADD(MONTH, DATEDIFF(MONTH, 0, CONVERT(DATE,'1 '+@TheMonth+' '+@TheYear,113)), 0))
          +@@DateFirst+(CHARINDEX(@TheDayOfWeek,'FriThuWedTueMonSunSat')-1)/3)%7
  END
  GO
  -- in SQL Server 2012 onwards, you can either use either the EXECUTE command or the SELECT command to
  --execute a function. The main difference is in the way that parameters with defaults are handled but
  --also the schema name is not required in the execute syntax.
  DECLARE @ret DateTime

  EXEC @ret = NthDayOfWeekOfMonth '2017', 'Jun', 'Fri',3

  SELECT @ret AS Third_Friday_In_June_2017
  EXEC @ret = NthDayOfWeekOfMonth '2017', 'Jun'

  SELECT @ret AS First_Sunday_In_June_2017

  SELECT dbo.NthDayOfWeekOfMonth('2017', 'May', DEFAULT, DEFAULT) AS 'Using default',
         dbo.NthDayOfWeekOfMonth('2017', 'May', 'Sun', 1) AS 'explicit'
  GO

--functions can be schema-bound -Well, just as when schema binding a view, schema binding a function  
--makes it more difficult to make changes to the underlying data structures that would break 
--our functions. 	
CREATE FUNCTION Sales.CalculateSalesOrderTotal (@SalesOrderID INT)
RETURNS MONEY
WITH SCHEMABINDING AS
BEGIN
  DECLARE @SalesOrderTotal AS MONEY ;
  SELECT  @SalesOrderTotal = 
            SUM(sod.LineTotal) 
            + soh.TaxAmt 
            + soh.Freight
  FROM    Sales.SalesOrderHeader AS soh
          INNER JOIN Sales.SalesOrderDetail AS sod
            ON soh.SalesOrderID = sod.SalesOrderID
  WHERE   soh.SalesOrderID = @SalesOrderId
  GROUP BY soh.TaxAmt, soh.Freight ;
  RETURN @SalesOrderTotal ;
END;
GO

--a scalar UDF called ProductCostDifference, which will compute the cost difference for a single product, 
--over a time range. AdventureWorks2008 database	
IF OBJECT_ID(N'Production.ProductCostDifference', N'FN') IS NOT NULL 
    DROP FUNCTION Production.ProductCostDifference ;
GO
 
CREATE FUNCTION Production.ProductCostDifference
    (
      @ProductId INT ,
      @StartDate DATETIME ,
      @EndDate DATETIME 
    )
RETURNS MONEY
AS 
    BEGIN
        DECLARE @StartingCost AS MONEY ;
        DECLARE @CostDifference AS MONEY ;
 
        SELECT TOP 1
                @StartingCost = pch.StandardCost
        FROM    Production.ProductCostHistory AS pch
        WHERE   pch.ProductID = @ProductId
                AND EndDate BETWEEN @StartDate
                                AND @EndDate
        ORDER BY StartDate ASC ;
 
        SELECT TOP 1
                @CostDifference = StandardCost - @StartingCost
        FROM    Production.ProductCostHistory AS pch
        WHERE   pch.ProductID = @ProductId
                AND EndDate BETWEEN @StartDate
                                AND @EndDate
        ORDER BY StartDate DESC ; 
 
        RETURN  @CostDifference ;
    END
	GO

--Scalar functions in the SELECT Clause
--QUERY 1
SELECT  ProductID ,
        Name AS ProductName ,
        Production.ProductCostDifference
          (ProductID, '2000-01-01', GETDATE())
           AS CostVariance
FROM    Production.Product ;
 
--QUERY 2
SELECT  ProductID ,
        Name AS ProductName ,
        Production.ProductCostDifference
         (ProductID, '2000-01-01', GETDATE())
          AS CostVariance
FROM    Production.Product
WHERE   Production.ProductCostDifference
          (ProductID, '2000-01-01', GETDATE())
            IS NOT NULL ;
GO

--Salary Level Function
CREATE FUNCTION ufn_GetSalaryLevel(@salary INT)
RETURNS NVARCHAR(10)
AS
BEGIN
  DECLARE @salaryLevel VARCHAR(10)
 IF (@salary < 30000)
   SET @salaryLevel = 'Low'
  ELSE IF(@salary >= 30000 AND @salary <= 50000)
   SET @salaryLevel = 'Average'
  ELSE
   SET @salaryLevel = 'High'
RETURN @salaryLevel
END;
 GO

 --Function parameters
 --The comma-separated list of parameters must be delimited by Parentheses, 
 --even if there are no parameters. Up to 2,100 parameters can be declared.
 --A default for the parameter can be defined. These parameters must have an ‘at’ sign (@)
 --as the first character.
 --Parameters can take the place only of constants; they cannot be used instead of table names, 
 --column names, or the names of other database objects. 
 --The values supplied to parameters cannot be expressions, only literals (e.g. 1546) or local variables 
 --(e.g. @TheResult).When you pass parameter values to a user-defined function that are too large 
 --(e.g. a Char(8) value to a CHAR(4) parameter, the data is truncated to the defined size without any 
 --error or warning.
 --All scalar data types except the timestamp is allowed for a parameter. . The non-scalar types, 
 --cursor and table, aren’t allowed, though a Table-Valued Parameter is.
 Create FUNCTION AsAList /* a function for creating short lists of strings */
    (
    @first VARCHAR(80),  @second VARCHAR(80) = NULL,  @third VARCHAR(80) = NULL,
    @fourth VARCHAR(80) = NULL,  @fifth VARCHAR(80) = NULL,  @sixth VARCHAR(80) = NULL,
    @seventh VARCHAR(80) = NULL,  @eighth VARCHAR(80) = NULL,  @ninth VARCHAR(80) = NULL,
    @tenth VARCHAR(80) = NULL
    )
  RETURNS VARCHAR(8000)
  WITH EXECUTE AS CALLER
  AS
    BEGIN
    RETURN @first + COALESCE(',' + @second, '') + COALESCE(',' + @third, '')
      + COALESCE(',' + @fourth, '') + COALESCE(',' + @fifth, '')+ COALESCE(',' + @sixth, '')
      + COALESCE(',' + @Seventh, '') + COALESCE(',' + @eighth, '')+ COALESCE(',' + @ninth, '')
      + COALESCE(',' + @tenth, '') 
    END
  GO
  DECLARE @ret VARCHAR(8000) = NULL;
  EXEC @ret = AsAList 'unus','duo','tres';
  SELECT @ret -- unus,duo,tres
  EXEC @ret = AsAList 'Aen','Taen','Tethera','Fethera','hubs','Aaylher','Layalher','Ouoather','Ouaather','Dugs'
  SELECT @ret -- Aen,Taen,Tethera,Fethera,hubs,Aaylher,Layalher,Ouoather,Ouaather,Dugs
  GO

--You can, of course, use this to create tables from lists but you can’t use the EXECUTE function. 
--This means that your lists have to be marked with an explicit DEFAULT when you go beyond the end 
--of the list.
Create FUNCTION AsATable /* an iTVF function for creating short tables */
    (
    @first VARCHAR(80),  @second VARCHAR(80) = NULL,  @third VARCHAR(80) = NULL,
    @fourth VARCHAR(80) = NULL,  @fifth VARCHAR(80) = NULL,  @sixth VARCHAR(80) = NULL,
    @seventh VARCHAR(80) = NULL,  @eighth VARCHAR(80) = NULL,  @ninth VARCHAR(80) = NULL,
    @tenth VARCHAR(80) = NULL
    )
  RETURNS table
  AS
  RETURN
  SELECT * FROM 
     (VALUES (1, @first),(2,@second),(3,@third),(4,@fourth),(5,@fifth),
             (6,@sixth),(7,@seventh),(8,@eighth),(9,@ninth),(10,@tenth))
  AS f(TheORDER, word)
  WHERE word IS NOT null
  GO
  SELECT * FROM dbo.AsATable('Aen','Taen','Tethera','Fethera','hubs','Aaylher','Layalher','Ouoather','Ouaather','Dugs')
  SELECT * FROM dbo.AsATable('Moanday','Tiresday','Woeday','Tearsday','Frightday','Sittingday','Sinday',default,default,default)
  GO

--Scalar functions in the WHERE Clause SLOW PERFORMANCE
SELECT  *
FROM    Sales.SalesOrderHeader AS soh
WHERE   DATEADD(mm, 12, soh.OrderDate) < GETDATE()
GO

--Scalar functions in the WHERE Clause IMPROVED PERFORMANCE 	
--Optimizing the use of a function in the WHERE clause isn’t always that easy,
--but in many occasions this problem can be alleviated through the use of careful design, 
--a computed column, or a view.
SELECT  *
FROM    Sales.SalesOrderHeader AS soh
WHERE   soh.OrderDate < DATEADD(mm, -12, GETDATE())
GO

--Table-valued functions.
--Similar to a view with parameters
--Return a table as a result of single SELECT statement

--A skeletal inline table function
CREATE FUNCTION dbo.MyInlineTableFunction
  ( @param1 INT, @param2 CHAR(5) )
RETURNS TABLE
AS
RETURN
  (
  SELECT @param1 AS c1, @param2 AS c2
  )
GO


--A skeletal Multi-statement table function
CREATE FUNCTION dbo.MyMultistatenetTableFunction
  (  @param1 INT, @param2 CHAR(5)  )
RETURNS @returntable TABLE
  (
  c1 INT, c2 CHAR(5)
  )
AS
  BEGIN
    INSERT @returntable SELECT @param1, @param2;
	RETURN;
  END;
  GO

--Single-statement Scalar to Single-statement TVF 	
IF OBJECT_ID(N'Sales.OrderWeight') IS NOT NULL 
    DROP FUNCTION Sales.OrderWeight ;
GO
 
IF OBJECT_ID(N'Sales.tvf_OrderWeight') IS NOT NULL 
    DROP FUNCTION Sales.tvf_OrderWeight ;
GO
 
CREATE FUNCTION Sales.OrderWeight ( @SalesOrderID INT )
RETURNS DECIMAL(18, 2)
AS 
    BEGIN
        DECLARE @Weight AS DECIMAL(18, 2) ;
      
        SELECT  @Weight = SUM(sod.OrderQty * p.Weight)
        FROM    Sales.SalesOrderDetail AS sod
                INNER JOIN Production.Product AS p
                       ON sod.ProductID = p.ProductID
        WHERE   sod.SalesOrderID = @SalesOrderID ;
      
        RETURN @Weight ;
    END
GO
 
CREATE FUNCTION Sales.tvf_OrderWeight ( )
RETURNS TABLE
AS
RETURN
    SELECT  sod.SalesOrderID ,
            SUM(sod.OrderQty * p.Weight) AS OrderWeight
    FROM    Sales.SalesOrderDetail AS sod
            INNER JOIN Production.Product AS p
                   ON sod.ProductID = p.ProductID
    GROUP BY sod.SalesOrderID ;
GO
 	
--calling the scalar function
SELECT  c.CustomerID ,
        AVG(OrderWeight) AS AverageOrderWeight
FROM    Sales.Customer AS c
        INNER JOIN ( SELECT soh.CustomerID ,
                            Sales.OrderWeight(soh.SalesOrderID)
                             AS OrderWeight
                     FROM   Sales.SalesOrderHeader AS soh
                     WHERE  soh.OrderDate BETWEEN '2000-01-01'
                                                   AND GETDATE()
                   ) AS x ON c.CustomerID = x.CustomerID
GROUP BY c.CustomerID
ORDER BY c.CustomerID ;
GO

-- calling the single-statement TVF
SELECT  c.CustomerID ,
        AVG(OrderWeight) AS AverageOrderWeight
FROM    Sales.Customer AS c
        INNER JOIN Sales.SalesOrderHeader AS soh
               ON c.CustomerID = soh.CustomerID
        INNER JOIN Sales.tvf_OrderWeight() AS y
               ON soh.SalesOrderID = y.SalesOrderID
GROUP BY c.CustomerID
ORDER BY c.CustomerID ;
GO

--Multi-statement Scalar to Multi-statement TVF	
--This TVF, Instead of retrieving a single row from the database and calculating the price difference, 
--pulls back all rows from the database and calculates the price difference for all rows at once.
IF OBJECT_ID(N'Production.tvf_ProductCostDifference') IS NOT NULL 
    DROP FUNCTION Production.tvf_ProductCostDifference ;
GO
 
CREATE FUNCTION [Production].[tvf_ProductCostDifference]
    (
      @StartDate DATETIME ,
      @EndDate DATETIME
    )
RETURNS TABLE
AS
RETURN
    WITH    cte
              AS ( SELECT   pch.ProductID ,
                            pch.StandardCost AS Cost ,
                            ROW_NUMBER() OVER ( PARTITION BY pch.ProductID ORDER BY StartDate ASC ) AS rn_1 ,
                            ROW_NUMBER() OVER ( PARTITION BY pch.ProductID ORDER BY StartDate DESC ) AS rn_2
                   FROM     Production.ProductCostHistory AS pch
                   WHERE    pch.EndDate BETWEEN @StartDate AND @EndDate
                 )
  -- Find the newest price for each product by using
  -- grabbing the first (x.rn_1 = 1) row.
  -- Then find the last row for each product with  
  -- x.rn_1 = y.rn_2. Since rn_2 is ordered by StartDate
  -- descending, the row in y where rn_2 = 1 is the 
  -- oldest order.
  SELECT    x.ProductID ,
            y.Cost - x.Cost AS CostDifference
  FROM      cte AS x
            INNER JOIN cte AS y ON x.ProductID = y.ProductID
                                   AND x.rn_1 = y.rn_2
  WHERE     x.rn_1 = 1 ;
  GO

--Aggregate functions (like SUM(…))
--Perform calculation over set of inputs values.
--Defined through external .NET functions.


--Stored Procedures
--Syntax: CREATE PROCEDURE … AS …
USE SoftUni
GO

CREATE PROC dbo.usp_SelectEmployeesBySeniority 
AS
  SELECT * 
  FROM Employees
  WHERE DATEDIFF(Year, HireDate, GETDATE()) > 5
GO

--Executing Stored Procedures
--Executing a stored procedure by EXEC.
EXEC usp_SelectEmployeesBySeniority
GO

--Executing a stored procedure within an INSERT statement.
INSERT INTO Customers
EXEC usp_SelectEmployeesBySeniority
GO

--Altering Stored Procedures
--Use the ALTER PROCEDURE statement
USE SoftUni
GO

ALTER PROC usp_SelectEmployeesBySeniority
AS
  SELECT FirstName, LastName, HireDate, 
    DATEDIFF(Year, HireDate, GETDATE()) as Years
  FROM Employees
  WHERE DATEDIFF(Year, HireDate, GETDATE()) > 5
  ORDER BY HireDate
GO

--Dropping Stored Procedures
--DROP PROCEDURE
DROP PROC usp_SelectEmployeesBySeniority
GO

--You could check if any objects depend on the stored procedure by executing the system stored 
--procedure sp_depends
EXEC sp_depends 'usp_SelectEmployeesBySeniority'
GO

--Defining Parameterized Procedures
--To define a parameterized procedure use the syntax:
--CREATE PROCEDURE usp_ProcedureName 
--[(@parameter1Name parameterType,
--  @parameter2Name parameterType,…)] AS

--Choose the parameter types carefully and provide appropriate default values
--CREATE PROC usp_SelectEmployeesBySeniority(
--@minYearsAtWork int = 5) AS
CREATE PROC usp_SelectEmployeesBySeniority(@minYearsAtWork int = 5)
AS
  SELECT FirstName, LastName, HireDate,
         DATEDIFF(Year, HireDate, GETDATE()) as Years
    FROM Employees
   WHERE DATEDIFF(Year, HireDate, GETDATE()) > @minYearsAtWork
   ORDER BY HireDate
GO

EXEC usp_SelectEmployeesBySeniority 10
GO

EXEC usp_SelectEmployeesBySeniority
GO

--Returning Values Using OUTPUT Parameters
CREATE PROCEDURE dbo.usp_AddNumbers
   @firstNumber SMALLINT,
   @secondNumber SMALLINT,
   @result INT OUTPUT
AS
   SET @result = @firstNumber + @secondNumber
GO

DECLARE @answer smallint
EXECUTE usp_AddNumbers 5, 6, @answer OUTPUT
SELECT 'The result is: ', @answer
GO
-- The result is: 11

--Employees with Three Projects
CREATE PROCEDURE udp_AssignProject (@EmployeeID INT, @ProjectID INT)
AS
BEGIN
DECLARE @maxEmployeeProjectsCount INT = 3
DECLARE @employeeProjectsCount INT
SET @employeeProjectsCount = 
(SELECT COUNT(*) 
   FROM [dbo].[EmployeesProjects] AS ep
   WHERE ep.EmployeeId = @EmployeeID)
BEGIN TRAN
INSERT INTO [dbo].[EmployeesProjects]  (EmployeeID, ProjectID)VALUES (@EmployeeID, @ProjectID)

IF(@employeeProjectsCount >= @maxEmployeeProjectsCount)
BEGIN
  RAISERROR('The employee has too many projects!', 16, 1)
  ROLLBACK
END
ELSE
   COMMIT
END
GO

--Withdraw Money
CREATE PROCEDURE usp_WithdrawMoney   @account INT,     @moneyAmount MONEY
AS
BEGIN
  BEGIN TRANSACTION
UPDATE Accounts SET Balance = Balance - @moneyAmount
WHERE Id = @account
IF @@ROWCOUNT <> 1
BEGIN
  ROLLBACK;
  RAISERROR('Invalid account!', 16, 1)
  RETURN
END
COMMIT
END
GO
