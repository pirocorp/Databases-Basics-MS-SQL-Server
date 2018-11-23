USE Orders
 GO

CREATE TABLE People(
	Id INT IDENTITY,
	[Name] NVARCHAR(50) NOT NULL,
	Birthday DATETIME2 NOT NULL,
	CONSTRAINT PK_Id
	PRIMARY KEY(Id) 
)
GO

INSERT INTO People
VALUES
(
       'Victor',
       '2000-12-07 00:00:00.000'
),
(
       'Steven',
       '1992-09-10 00:00:00.000'
),
(
       'Stephen',
       '1910-09-19 00:00:00.000'
),
(
       'John',
       '2010-01-06 00:00:00.000'
);

SELECT 
	   [Name],
	   DATEDIFF(YEAR, Birthday, GETDATE()) AS [Age in Years],
	   DATEDIFF(MONTH, Birthday, GETDATE()) AS [Age in Months],
	   DATEDIFF(DAY, Birthday, GETDATE()) AS [Age in Days], 
	   DATEDIFF(MINUTE, Birthday, GETDATE()) AS [Age in Minutes] 	    
  FROM People