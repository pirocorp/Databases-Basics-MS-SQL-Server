CREATE OR ALTER PROCEDURE usp_GetTownsStartingWith(@StartWith NVARCHAR(50))
                       AS
                   SELECT [Name] AS Town
	          	     FROM Towns
	          	    WHERE SUBSTRING([Name], 1, LEN(@StartWith)) = @StartWith
	                   GO

EXEC usp_GetTownsStartingWith 'b'
GO