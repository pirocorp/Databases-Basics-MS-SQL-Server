--Task 7

CREATE TABLE [People](
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(200) NOT NULL,
	[Picture] VARBINARY(MAX), 
	[Height] DECIMAL(2),
	[Weight] DECIMAL(2),
	[Gender] BIT NOT NULL,
	[Birthdate] DATE NOT NULL,
	[Biography] NVARCHAR(MAX)
)
GO

INSERT INTO [People] ([Name], [Gender], [Birthdate])
	 VALUES	('Piro', 1, '2018-07-12'),
			('Piro2', 1, '2018-08-12'),
			('Piro3', 1, '2018-09-12'),
			('Piro4', 1, '2018-10-12'),
			('Piro5', 1, '2018-11-20')
		GO

--Task 8
CREATE TABLE [Users](
	[Id] BIGINT PRIMARY KEY IDENTITY,
	[Username] VARCHAR(30) NOT NULL UNIQUE,
	[Password] VARCHAR(26) NOT NULL,
	[ProfilePicture] VARBINARY(MAX), 
	[LasLoginTime] DATETIME2,
	[IsDeleted] BIT
)
GO

INSERT INTO [Users] ([Username], [Password])
	 VALUES ('piro1', '12345'),
			('piro2', '12345'),
			('piro3', '12345'),
			('piro4', '12345'),
			('piro5', '12345')
		 GO

-- Task 9
    ALTER TABLE [Users]
DROP CONSTRAINT PK__Users__3214EC07D174533A

   ALTER TABLE [Users]
ADD CONSTRAINT PK_Users_Id_Username PRIMARY KEY CLUSTERED ([Id], [Username])

-- Task 10
ALTER TABLE [Users]
  ADD CHECK (LEN ([Password]) >= 5)

-- Task 11
   ALTER TABLE [Users]
ADD CONSTRAINT DF_Users_LasLoginTime
       DEFAULT GETDATE()
	       FOR [LasLoginTime]

-- Task 12
    ALTER TABLE [Users]
DROP CONSTRAINT PK_Users_Id_Username

   ALTER TABLE [Users]
ADD CONSTRAINT PK_Users_Id PRIMARY KEY CLUSTERED ([Id])
