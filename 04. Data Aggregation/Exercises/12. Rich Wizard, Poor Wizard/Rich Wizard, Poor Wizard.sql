--CTE Solution
  WITH Wizards AS(SELECT FirstName AS [Host Wizard],
                  	     DepositAmount AS [Host Wizard Deposit],
                  	     LEAD(FirstName, 1) OVER (ORDER BY Id) AS [Guest Wizard],
                  	     LEAD(DepositAmount, 1) OVER (ORDER BY Id) AS [Guest Wizard Deposit],
                  	     DepositAmount - LEAD(DepositAmount, 1) OVER (ORDER BY Id) AS [Difference]
                    FROM WizzardDeposits)
SELECT SUM([Difference]) AS SumDifference
  FROM Wizards
    GO

--SUB Query Solution
SELECT SUM([Difference]) AS SumDifference
  FROM (SELECT FirstName AS [Host Wizard],
                  	     DepositAmount AS [Host Wizard Deposit],
                  	     LEAD(FirstName, 1) OVER (ORDER BY Id) AS [Guest Wizard],
                  	     LEAD(DepositAmount, 1) OVER (ORDER BY Id) AS [Guest Wizard Deposit],
                  	     DepositAmount - LEAD(DepositAmount, 1) OVER (ORDER BY Id) AS [Difference]
                    FROM WizzardDeposits
       ) 
	AS Wizzards