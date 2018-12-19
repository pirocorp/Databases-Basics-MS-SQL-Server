UPDATE UsersGames
   SET Cash += 50000
 WHERE UserId IN (SELECT Id
                    FROM Users
                   WHERE Username IN ('baleremuda', 'loosenoise', 'inguinalself', 'buildingdeltoid', 'monoxidecos'))
   AND GameId = ( SELECT Id
                    FROM Games
                   WHERE [Name] = 'Bali')

SELECT *
  FROM UsersGames
 WHERE UserId IN (SELECT Id
                    FROM Users
                   WHERE Username IN ('baleremuda', 'loosenoise', 'inguinalself', 'buildingdeltoid', 'monoxidecos'))
   AND GameId = ( SELECT Id
                    FROM Games
                   WHERE [Name] = 'Bali')
