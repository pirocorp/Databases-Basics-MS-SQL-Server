CREATE OR ALTER FUNCTION ufn_CashInUsersGames(@gameName NVARCHAR(MAX))
                 RETURNS @SumCashTable TABLE (SumCash MONEY) 
                      AS
                   BEGIN 
				         INSERT INTO @SumCashTable (SumCash)
						      SELECT SUM(Cash)
                                FROM (SELECT ug.Cash,
                                     	       g.[Name],
                                     		   DENSE_RANK() OVER(PARTITION BY g.[Name] ORDER BY ug.Cash DESC) AS [Rank]
                                           FROM UsersGames AS ug
                                     INNER JOIN Games AS g
                                             ON g.Id = ug.GameId) AS RankedGames
                               WHERE ([Rank] % 2) <> 0
                            GROUP BY [Name]
                              HAVING [Name] = @gameName
							  RETURN
				     END
					  GO

SELECT *
  FROM dbo.ufn_CashInUsersGames ('Love in a mist')
    GO