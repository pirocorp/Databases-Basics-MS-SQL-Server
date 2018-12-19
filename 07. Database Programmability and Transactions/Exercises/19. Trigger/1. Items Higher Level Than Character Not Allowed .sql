CREATE OR ALTER TRIGGER tr_UserGameItemsInsert ON UserGameItems INSTEAD OF INSERT 
	                 AS
			    DECLARE @CharacterLevel INT = (SELECT [Character Level] 
				                                 FROM (    SELECT ug.[Level] AS [Character Level],
                                                                  i.MinLevel AS [Item Min Level]
                                                             FROM inserted AS ugi
                                                       INNER JOIN Items AS i
                                                               ON i.Id = ugi.ItemId
                                                       INNER JOIN UsersGames AS ug
                                                               ON ug.Id = ugi.UserGameId) AS CarItemLevel)

			    DECLARE @ItemLevel INT = (SELECT [Item Min Level] 
				                                 FROM (    SELECT ug.[Level] AS [Character Level],
                                                                  i.MinLevel AS [Item Min Level]
                                                             FROM inserted AS ugi
                                                       INNER JOIN Items AS i
                                                               ON i.Id = ugi.ItemId
                                                       INNER JOIN UsersGames AS ug
                                                               ON ug.Id = ugi.UserGameId) AS CarItemLevel)
				     IF (@ItemLevel <= @CharacterLevel)
			 	  BEGIN 
				  		    INSERT INTO UserGameItems
                 SELECT ItemId,
				        UserGameId
				   FROM inserted
				     --    ROLLBACK
			      --      RAISERROR('Character level is too low', 16, 2)
						   --RETURN
				    END
					 GO


INSERT INTO UserGameItems
VALUES(1, 26)

SELECT *
  FROM UserGameItems
 WHERE ItemId = 1
