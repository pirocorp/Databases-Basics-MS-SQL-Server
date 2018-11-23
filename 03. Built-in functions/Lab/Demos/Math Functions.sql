--basic arithmetic operations
USE Demo
 GO

SELECT Id,
		A,
		H,
       (A * H) / 2 AS Area
  FROM Triangles2
    GO

--PI – get the value of Pi as float (15 –digit precision)
SELECT PI() --3.14159265358979
	GO

--ABS – absolute value
--ABS(Value)
SELECT ABS(5)
SELECT ABS(-5)
	GO

--SQRT – square root (result will be float)
--SQRT(Value)
SELECT SQRT(16)
	GO

--SQUARE – raise to power of two
--SQUARE(Value)
SELECT SQUARE(4)
SELECT SQUARE(-4)
	GO

--Find the length of a line by given coordinates of end points
SELECT Id,
       SQRT(SQUARE(X1-X2) + SQUARE(Y1-Y2))
    AS [Length]
  FROM Lines
    GO

--POWER – raise value to desired exponent
--POWER(Value, Exponent)
SELECT POWER(4, 4)
	GO

--ROUND – obtain desired precision
--Negative precision rounds characters before decimal point
--ROUND(Value, Precision)
SELECT ROUND(14693.5356, 4)
SELECT ROUND(14693.5356, 2)
SELECT ROUND(14693.5356, 0)
SELECT ROUND(14693.5356, -1)
SELECT ROUND(14693.5356, -2)
	GO

--FLOOR & CEILING – return the nearest integer
--FLOOR(Value)
--CEILING(Value)
SELECT FLOOR(13.999)
SELECT CEILING(13.001)
	GO

--Calculate the required number of pallets to ship each item
--BoxCapacity specifies how many items can fit in one box
--PalletCapacity specifies how many boxes can fit in a pallet

SELECT 
	   CEILING(
		CEILING(
		CAST(Quantity AS float) / BoxCapacity) / PalletCapacity) 
	   AS [Number of pallets]
  FROM Products
	GO

--SIGN – returns 1, -1 or 0, depending on value sign
SELECT SIGN(-10)
SELECT SIGN(10)
SELECT SIGN(0)
	GO

--RAND – get a random float value in range [0,1)
--If Seed is not specified, one is assigned at random
SELECT RAND()
SELECT RAND(56)
	GO

