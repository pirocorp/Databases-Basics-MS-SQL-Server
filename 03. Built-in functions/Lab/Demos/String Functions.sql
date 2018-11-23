--Concatenation Ц combine strings
   USE SoftUni
SELECT FirstName + ' ' + LastName
    AS [Full Name]
  FROM Employees
    GO

--CONCAT replaces NULL values with empty string
SELECT CONCAT(FirstName + ' ', MiddleName + ' ', LastName)
    AS [Full Name]
  FROM Employees
    GO

--SUBSTRING Ц extract part of a string Index is 1-based!
--SUBSTRING(String, StartIndex, Length)
SELECT SUBSTRING('SoftUni', 5, 3)
    GO

--REPLACE Ц replace specific string with another
--REPLACE(String, Pattern, Replacement)
SELECT REPLACE('SoftUni', 'Soft', 'Hard')
	GO

--LTRIM & RTRIM Ц remove spaces from either side of string
--LTRIM(String)
--RTRIM(String)
SELECT LTRIM('   PESHO')
SELECT RTRIM('PESHO                ')
	GO

--LEN Ц counts the number of characters LEN(String)
SELECT LEN('PESHO')
SELECT LEN('   PESHO')
SELECT LEN('PESHO   ')
	GO

--DATALENGTH Ц get number of used bytes (double for Unicode)
--DATALENGTH(String)
--N prefix change string to Unicode
SELECT DATALENGTH(N'ѕешо')
SELECT DATALENGTH(N'     ѕешо')
SELECT DATALENGTH(N'ѕешо     ')
	GO

--LEFT & RIGHT Ц get characters from beginning or end of string
--LEFT(String, Count)
--RIGHT(String, Count)
USE Diablo
SELECT Id, [Start],
       LEFT([Name], 3) AS [LEFT],
	   RIGHT([Name], 3) AS [RIGHT],
	   [Name]
  FROM Games
    GO

--Obfuscate CC Numbers
USE Demo
 GO

CREATE VIEW v_PublicPaymentInfo AS
 SELECT 
	    CustomerID,
	    FirstName,
	    LastName,
	    LEFT(PaymentNumber, 6) + 
		   REPLICATE('*', LEN(PaymentNumber) - 6) 
		AS [CC Number]
   FROM Customers
     GO

SELECT *
  FROM v_PublicPaymentInfo
    GO

--LOWER & UPPER Ц change letter casing
--LOWER(String)
--UPPER(String)
SELECT 
	   LOWER(FirstName) AS [First Name],
	   UPPER(LastName) AS [Last Name]
  FROM Customers
    GO

--REVERSE Ц reverse order of all characters in string
--REVERSE(String)
SELECT 
	   REVERSE(FirstName) AS [First Name],
	   REVERSE(LastName) AS [Last Name]
  FROM Customers
    GO

--REPLICATE Ц repeat string
--REPLICATE(String, Count)
SELECT REPLICATE('Test', 5)
	GO

--CHARINDEX Ц locate specific pattern (substring) in string
--CHARINDEX(Pattern, String, [StartIndex])
SELECT CHARINDEX('Soft', 'SoftUniSoft')
SELECT CHARINDEX('Soft', 'SoftUniSoft', 2)
	GO

--STUFF Ц insert substring at specific position
--STUFF(String, StartIndex, Length, Substring)
SELECT STUFF('SoftUni', 5, 0, ' ')
SELECT STUFF('SoftUni', 5, 0, 'TEST')
SELECT STUFF('SoftUni', 1, 1, 'L')
SELECT STUFF('SoftUni', 1, 4, '')
SELECT STUFF('SoftUni', 1, 4, 'TEST')
SELECT STUFF('SoftUni', 1, 4, 'SOMETHING ELSE ')
    GO