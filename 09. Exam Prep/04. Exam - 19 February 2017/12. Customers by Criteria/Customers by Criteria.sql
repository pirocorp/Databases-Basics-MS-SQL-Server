  SELECT FirstName,
         Age,
  	     PhoneNumber 
    FROM Customers
   WHERE (Age >= 21 AND FirstName LIKE '%an%')
      OR (PhoneNumber LIKE '%38' AND Id NOT IN (SELECT Id FROM Countries WHERE Name = 'Greece'))
ORDER BY FirstName ASC,
         Age DESC