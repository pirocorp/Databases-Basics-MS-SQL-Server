--Supported characters include

--%    -- any string, including zero-length
--_    -- any single character
--[…]  -- any character within range
--[^…] -- any character not in the range

--ESCAPE – specify prefix to treat special characters as normal
--SELECT ID, Name
--  FROM Tracks
-- WHERE Name LIKE '%max!%' ESCAPE '!'