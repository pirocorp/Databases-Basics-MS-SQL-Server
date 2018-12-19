DECLARE @Users TABLE
(
 Id INT
)

INSERT INTO @Users
SELECT Id
  FROM UsersGames
 WHERE UserId IN (SELECT Id
                    FROM Users
                   WHERE Username IN ('baleremuda', 'loosenoise', 'inguinalself', 'buildingdeltoid', 'monoxidecos'))
   AND GameId = ( SELECT Id
                    FROM Games
                   WHERE [Name] = 'Bali')

DECLARE @Items TABLE
(
 Id INT
)

INSERT INTO @Items
SELECT Id
  FROM Items
 WHERE Id BETWEEN 251 AND 299
    OR Id BETWEEN 501 AND 539

DECLARE @Total DECIMAL(15, 2) = (SELECT SUM(Price)
                                   FROM Items
                                  WHERE Id BETWEEN 251 AND 299
                                     OR Id BETWEEN 501 AND 539)

DECLARE @ItemsToBeBought TABLE
(
 [Item ID] INT,
 [User ID] INT
)

INSERT INTO @ItemsToBeBought
     SELECT i.Id AS [Item ID],
	        u.Id AS [User ID]
       FROM @Users AS u
 CROSS JOIN @Items AS i
   ORDER BY u.Id, i.Id

WHILE (SELECT COUNT(*) FROM @ItemsToBeBought) > 0
BEGIN
  
      DECLARE @ItemID INT = (SELECT TOP (1) [Item ID] FROM @ItemsToBeBought)
      DECLARE @UserID INT = (SELECT TOP (1) [User ID] FROM @ItemsToBeBought)
	   
	  BEGIN TRANSACTION 
      INSERT INTO UserGameItems
	  VALUES (@ItemID, @UserID)
	  COMMIT

	  UPDATE UsersGames
	     SET Cash -= (SELECT Price FROM Items WHERE Id = (SELECT TOP (1) [Item ID] FROM @ItemsToBeBought))
	   WHERE Id = (SELECT TOP (1) [User ID] FROM @ItemsToBeBought)

	  DELETE TOP (1)
	    FROM @ItemsToBeBought    
 END
 GO


  SELECT *
  FROM UsersGames
 WHERE UserId IN (SELECT Id
                    FROM Users
                   WHERE Username IN ('baleremuda', 'loosenoise', 'inguinalself', 'buildingdeltoid', 'monoxidecos'))
   AND GameId = ( SELECT Id
                    FROM Games
                   WHERE [Name] = 'Bali')

SELECT COUNT(*)
  FROM UserGameItems

DELETE UserGameItems
 WHERE ItemId = 251
   AND UserGameId = 296
