DECLARE @UserId INT = (SELECT Id
                         FROM Users
                        WHERE Username = 'Alex')

DECLARE @GameId INT = (SELECT Id
                         FROM Games
                        WHERE [Name] = 'Edinburgh')

DECLARE @UserGameId INT = (SELECT Id
                             FROM UsersGames
							WHERE GameId = @GameId
							  AND UserId = @UserId)

DECLARE @ItemsTotalCost DECIMAL(15, 4) = (SELECT SUM(Price)
                                            FROM Items
                                           WHERE [Name] 
										      IN ('Blackguard', 'Bottomless Potion of Amplification', 
											      'Eye of Etlich (Diablo III)', 'Gem of Efficacious Toxin', 
												  'Golden Gorget of Leoric', 'Hellfire Amulet'))
BEGIN
BEGIN TRANSACTION

	BEGIN TRY
		INSERT INTO UserGameItems
		SELECT Id, @UserGameId
		  FROM Items
		  WHERE [Name] 
		     IN ('Blackguard', 'Bottomless Potion of Amplification', 
			     'Eye of Etlich (Diablo III)', 'Gem of Efficacious Toxin', 
				 'Golden Gorget of Leoric', 'Hellfire Amulet')
	END TRY
	BEGIN CATCH
		ROLLBACK
		RETURN
	END CATCH

	BEGIN TRY
		UPDATE UsersGames
		SET Cash -= @ItemsTotalCost
		WHERE Id = @UserGameId
    END TRY
	BEGIN CATCH
		ROLLBACK
		RETURN
	END CATCH
COMMIT
END	

SELECT u.Username,
       g.[Name],
	   ug.Cash,
	   i.[Name] AS [Item Name]
  FROM UsersGames AS ug
  JOIN Users AS u
    ON u.Id = ug.UserId
  JOIN Games AS g
    ON g.Id = ug.GameId
  JOIN UserGameItems AS ugi
    ON ugi.UserGameId = ug.Id
  JOIN Items AS i
    ON i.Id = ugi.ItemId
 WHERE GameId = @GameId
 ORDER BY i.[Name]
  