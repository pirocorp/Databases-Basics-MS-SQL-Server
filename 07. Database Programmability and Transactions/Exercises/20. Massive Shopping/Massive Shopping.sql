--@UserId scalar varible stores Id for Specified user in specified game	
	DECLARE @UserId INT = (    SELECT ug.Id
                                 FROM UsersGames AS ug     
                           INNER JOIN Games AS g
                                   ON g.Id = ug.GameId
                           INNER JOIN Users AS u
                                   ON u.Id = ug.UserId
                                WHERE u.Username = 'Stamat'
                                  AND g.[Name] = 'Safflower')

--@UserGameId table varible stores same as @UserId but in table will be used in cross join
	DECLARE @UserGameId TABLE(Id INT)
INSERT INTO @UserGameId
     SELECT ug.Id
       FROM UsersGames AS ug     
 INNER JOIN Games AS g
         ON g.Id = ug.GameId
 INNER JOIN Users AS u
         ON u.Id = ug.UserId
      WHERE u.Username = 'Stamat'
        AND g.[Name] = 'Safflower'

--@UserGameCash here we will store current cash for the given user
DECLARE @UserGameCash DECIMAL(15, 2)	

--@FirstItems table varible stores ids of items we need to insert
    DECLARE @FirstItems TABLE(Id INT)
INSERT INTO @FirstItems
     SELECT Id 
       FROM Items
      WHERE MinLevel IN (11, 12)

--@FirstItemsTotalPrice total price of items
DECLARE @FirstItemsTotalPrice DECIMAL(15,2) = (SELECT SUM(Price)
                                                 FROM Items
												WHERE ID IN (SELECT Id 
                                                               FROM Items
                                                              WHERE MinLevel IN (11, 12)))

--@SecondItems table varible stores ids of items we need to insert
    DECLARE @SecondItems TABLE(Id INT)
INSERT INTO @SecondItems
     SELECT Id 
       FROM Items
      WHERE MinLevel IN (19, 20, 21)

--@FirstItemsTotalPrice total price of items
DECLARE @SecondItemsTotalPrice DECIMAL(15,2) = (SELECT SUM(Price)
                                                 FROM Items
												WHERE ID IN (SELECT Id 
                                                               FROM Items
                                                              WHERE MinLevel IN (19, 20, 21)))

--Setting current cash value
SET @UserGameCash = (SELECT Cash FROM UsersGames WHERE Id = @UserId)

--First transaction i still prefer to check if condition is met then we make changes
BEGIN TRANSACTION
               IF (@FirstItemsTotalPrice <= @UserGameCash)
            BEGIN
			          INSERT INTO UserGameItems
				      SELECT *
                        FROM @FirstItems
                  CROSS JOIN @UserGameId

				  UPDATE UsersGames 
				     SET Cash -= @FirstItemsTotalPrice
				   WHERE Id = @UserId
              END
COMMIT

--Setting current cash value
SET @UserGameCash = (SELECT Cash FROM UsersGames WHERE Id = @UserId)

--Second transaction is same as first
BEGIN TRANSACTION
               IF (@SecondItemsTotalPrice <= @UserGameCash)
            BEGIN
			          INSERT INTO UserGameItems
				      SELECT *
                        FROM @SecondItems
                  CROSS JOIN @UserGameId

				  UPDATE UsersGames 
				     SET Cash -= @SecondItemsTotalPrice
				   WHERE Id = @UserId
              END
COMMIT

--Displaing result
    SELECT i.[Name] AS [Item Name]
      FROM UserGameItems AS ugi
INNER JOIN Items AS i
        ON i.Id = ugi.ItemId
INNER JOIN UsersGames AS ug
        ON ug.Id = ugi.UserGameId
INNER JOIN Games AS g
        ON g.Id = ug.GameId
     WHERE UserGameId = 110
	   AND g.[Name] = 'Safflower'
  ORDER BY i.[Name]