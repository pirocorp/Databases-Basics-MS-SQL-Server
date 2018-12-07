SELECT DISTINCT u.Username
           FROM Users AS u
           JOIN Reports AS r
             ON r.UserId = u.Id
          WHERE COALESCE(TRY_PARSE(LEFT(u.Username, 1) AS INT), TRY_PARSE(RIGHT(u.Username, 1) AS INT)) = CategoryId
       ORDER BY u.Username