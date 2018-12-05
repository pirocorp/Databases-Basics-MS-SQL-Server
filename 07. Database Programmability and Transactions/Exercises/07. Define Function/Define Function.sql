CREATE OR ALTER FUNCTION ufn_IsWordComprised(@SetOfChars NVARCHAR(MAX), @InputWord NVARCHAR(MAX))
             RETURNS BIT 
                      AS
                   BEGIN 
	         			 DECLARE @CurrentChar NVARCHAR(1)
	         			 DECLARE @Word NVARCHAR(Max) = @InputWord
						   WHILE (@SetOfChars != '')
						   BEGIN
								   SET @CurrentChar = RIGHT(@SetOfChars, 1)
	         					    IF (CHARINDEX(@CurrentChar, @Word) > 0)
	         					 BEGIN
								       SET @Word = REPLACE(@Word, @CurrentChar, '')--stuff(@Word, charindex(@CurrentChar, @Word), 1, '')
	         					   END
								   SET @SetOfChars = SUBSTRING(@SetOfChars, 1, LEN(@SetOfChars) - 1)
							 END
	         			 DECLARE @Result BIT
						  SELECT @Result = CASE   
						                   WHEN LEN(@Word) > 0 THEN 0  
						                   ELSE 1 
						               END
						  RETURN @Result   
                     END 
	         	      GO

SELECT dbo.ufn_IsWordComprised('oistmiahf', 'Shammi')
    GO