CREATE OR ALTER FUNCTION ufn_CashInUsersGames(@gameName NVARCHAR(MAX))
                 RETURNS @SumCashTable TABLE (SumCash MONEY) 
                      AS
                   BEGIN 
				         INSERT INTO @SumCashTable (SumCash)
						      SELECT SUM(Cash)
                                FROM (    SELECT ug.Cash,
                                      		     ROW_NUMBER() OVER(ORDER BY ug.Cash DESC) AS [Rank]
                                            FROM UsersGames AS ug
                                      INNER JOIN Games AS g
                                              ON g.Id = ug.GameId
										   WHERE g.[Name] = @gameName) AS RankedGames
                               WHERE ([Rank] % 2) <> 0
							  RETURN
				     END
					  GO

SELECT *
  FROM dbo.ufn_CashInUsersGames ('Love in a mist')
    GO