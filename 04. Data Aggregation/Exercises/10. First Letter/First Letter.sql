 --Without Group BY Solution
  SELECT DISTINCT LEFT(FirstName, 1) AS FirstLetter
    FROM WizzardDeposits
   WHERE DepositGroup = 'Troll Chest'
      GO

--Group BY Solution
  SELECT LEFT(FirstName, 1) AS FirstLetter
    FROM WizzardDeposits
   WHERE DepositGroup = 'Troll Chest'
GROUP BY LEFT(FirstName, 1)
      GO