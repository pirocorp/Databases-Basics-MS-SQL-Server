--Solution with Common Table Expressions
  WITH WizardAges([Age]) 
    AS (SELECT [Age] =
               CASE  
                    WHEN  Age <= 10 THEN '[0-10]'  
                    WHEN  Age <= 20 THEN '[11-20]'  
                    WHEN  Age <= 30 THEN '[21-30]'  
                    WHEN  Age <= 40 THEN '[31-40]'
  		            WHEN  Age <= 50 THEN '[41-50]'
  		            WHEN  Age <= 60 THEN '[51-60]'
                    ELSE '[61+]' 
                END
          FROM WizzardDeposits)
  SELECT Age,
         COUNT(Age) AS WizardCount
    FROM WizardAges
GROUP BY Age
      GO