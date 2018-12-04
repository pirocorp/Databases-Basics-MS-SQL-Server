CREATE OR ALTER FUNCTION ufn_GetSalaryLevel (@Salary DECIMAL(18,4))
RETURNS NVARCHAR(8)
    AS
 BEGIN
DECLARE @SalaryLevel NVARCHAR(8)
 SELECT @SalaryLevel = CASE   
                            WHEN @Salary < 30000 THEN 'Low'  
                            WHEN @Salary > 50000 THEN 'High'  
                            ELSE 'Average' 
	                    END
RETURN @SalaryLevel   
   END
    GO

SELECT Salary,
	   dbo.ufn_GetSalaryLevel(e.Salary)
  FROM Employees AS e
    GO