-- Task 1
CREATE DATABASE School
GO

USE School
GO

CREATE TABLE [Students] (
	[Id] INT PRIMARY KEY IDENTITY
	,[FirstName] NVARCHAR(30) NOT NULL
	,[MiddleName] NVARCHAR(25)
	,[LastName] NVARCHAR(30) NOT NULL
	,[Age] INT 
	,CONSTRAINT CHK_Age_Students CHECK ([Age] >= 5 AND [Age] <= 100)
	,[Address] NVARCHAR(30)
	,[Phone] NCHAR(10)
)

CREATE TABLE [Subjects] (
	[Id] INT PRIMARY KEY IDENTITY
	,[Name] NVARCHAR(20) NOT NULL
	,[Lessons] INT NOT NULL
	,CONSTRAINT CHK_Lessons_Subjects CHECK ([Lessons] > 0)
)

CREATE TABLE [StudentsSubjects] (
	[Id] INT PRIMARY KEY IDENTITY
	,[StudentId] INT NOT NULL
	,CONSTRAINT FK_StudentsSubjects_Students FOREIGN KEY ([StudentId]) REFERENCES [Students]([Id])
	,[SubjectId] INT NOT NULL
	,CONSTRAINT FK_StudentsSubjects_Subjects FOREIGN KEY ([SubjectId]) REFERENCES [Subjects]([Id])
	,[Grade] DECIMAL(4, 2) NOT NULL
	,CONSTRAINT CHK_Grade_StudentsSubjects CHECK ([Grade] >= 2 AND [Grade] <= 6)
)

CREATE TABLE [Exams] (
	[Id] INT PRIMARY KEY IDENTITY
	,[Date] DATETIME2
	,[SubjectId] INT NOT NULL
	,CONSTRAINT FK_Exams_Subjects FOREIGN KEY ([SubjectId]) REFERENCES [Subjects]([Id])	
)

CREATE TABLE [StudentsExams] (
	[StudentId] INT NOT NULL
	,CONSTRAINT FK_StudentsExams_Students FOREIGN KEY ([StudentId]) REFERENCES [Students]([Id])
	,[ExamId] INT NOT NULL
	,CONSTRAINT FK_StudentsExams_Exams FOREIGN KEY ([ExamId]) REFERENCES [Exams]([Id])
	,PRIMARY KEY ([StudentId], [ExamId])
	,[Grade] DECIMAL(4, 2) NOT NULL
	,CONSTRAINT CHK_Grade_StudentsExams CHECK ([Grade] >= 2 AND [Grade] <= 6)
)

CREATE TABLE [Teachers] (
	[Id] INT PRIMARY KEY IDENTITY
	,[FirstName] NVARCHAR(20) NOT NULL
	,[LastName] NVARCHAR(20) NOT NULL
	,[Address] NVARCHAR(20) NOT NULL
	,[Phone] NCHAR(10)
	,[SubjectId] INT NOT NULL
	,CONSTRAINT FK_Teachers_Subjects FOREIGN KEY ([SubjectId]) REFERENCES [Subjects]([Id])	
)

CREATE TABLE [StudentsTeachers](
	[StudentId] INT NOT NULL
	,CONSTRAINT FK_StudentsTeachers_Students FOREIGN KEY ([StudentId]) REFERENCES [Students]([Id])
	,[TeacherId] INT NOT NULL
	,CONSTRAINT FK_StudentsTeachers_Teachers FOREIGN KEY ([TeacherId]) REFERENCES [Teachers]([Id])
	,PRIMARY KEY ([StudentId], [TeacherId])
)

-- Task 2
INSERT INTO [Teachers]
VALUES ('Ruthanne', 'Bamb', '84948 Mesta Junction', '3105500146', 6)
	   ,('Gerrard', 'Lowin', '370 Talisman Plaza', '3324874824', 2)
	   ,('Merrile', 'Lambdin', '81 Dahle Plaza', '4373065154', 5)
	   ,('Bert', 'Ivie', '2 Gateway Circle', '4409584510', 4)

INSERT INTO [Subjects]
VALUES ('Geometry', 12)
	  ,('Health', 10)
	  ,('Drama', 7)
	  ,('Sports', 9)

-- Task 3
UPDATE [StudentsSubjects]
   SET [Grade] = 6
 WHERE [SubjectId] IN (1, 2)
   AND [Grade] >= 5.50

-- Task 4
DELETE [StudentsTeachers]
 WHERE [TeacherId] IN (SELECT Id FROM Teachers WHERE [Phone] LIKE '%72%')

DELETE [Teachers]
 WHERE [Phone] LIKE '%72%'

-- Task 5
  SELECT [FirstName]
		,[LastName]
		,[Age]
    FROM [Students]
   WHERE [Age] >= 12
ORDER BY [FirstName]
		,[LastName]

-- Task 6
   SELECT [FirstName]
		 ,[LastName]
		 ,COUNT([ST].[TeacherId]) AS [TeachersCount]
     FROM [Students] AS [S]
LEFT JOIN [StudentsTeachers] AS [ST]
       ON [S].[Id] = [ST].[StudentId]
 GROUP BY [FirstName]
		 ,[LastName]

-- Task 7
   SELECT CONCAT([S].[FirstName], ' ', [S].[LastName]) AS [Full Name]
     FROM [Students] AS [S]
LEFT JOIN [StudentsExams] AS [SE]
       ON [S].[Id] = [SE].[StudentId]
	WHERE [SE].[Grade] IS NULL
 ORDER BY [Full Name]

-- Task 8
  SELECT TOP(10)
		 [S].[FirstName]
        ,[S].[LastName]
		,CONVERT(DECIMAL(4,2), (AVG([SE].[Grade]))) AS [Grade]
    FROM [Students] AS [S]
    JOIN [StudentsExams] AS [SE]
      ON [S].[Id] = [SE].[StudentId]
GROUP BY [S].[FirstName]
        ,[S].[LastName]
ORDER BY [Grade] DESC
		,[S].[FirstName] ASC
        ,[S].[LastName] ASC

-- Task 9
   SELECT [Full Name] =
				CASE
					WHEN [S].[MiddleName] IS NULL THEN CONCAT([S].[FirstName], ' ', [S].[LastName])
					ELSE CONCAT([S].[FirstName], ' ', [S].[MiddleName], ' ', [S].[LastName])
				END
     FROM [Students] AS [S]
LEFT JOIN [StudentsSubjects] AS [SS]
       ON [S].[Id] = [SS].[StudentId]
	WHERE [SS].[SubjectId] IS NULL
 ORDER BY [Full Name]

 -- Task 10
  SELECT [S].[Name]
		,AVG([SS].[Grade]) AS [AverageGrade]
    FROM [Subjects] AS [S]
    JOIN [StudentsSubjects] AS [SS]
      ON [S].[Id] = [SS].[SubjectId]
GROUP BY [S].[Name]
		,[S].[Id]
ORDER BY [S].[Id] ASC
GO

-- Task 11
CREATE OR ALTER FUNCTION udf_ExamGradesToUpdate(@studentId INT, @grade DECIMAL(4, 2))
RETURNS NVARCHAR(MAX)
AS
BEGIN
	IF (SELECT [Id] FROM [Students] WHERE [Id] = @studentId) IS NULL
		RETURN CONCAT('The student with provided', ' ', 'id does not exist in the school!')

	IF(@grade > 6)
		RETURN 'Grade cannot be above 6.00!'

	DECLARE @count INT
	SET @count = (SELECT COUNT([Grade]) 
				    FROM [StudentsExams]
				   WHERE [StudentId] = @studentId
				     AND [Grade] >= (@grade - 0.50)
				     AND [Grade] <= (@grade + 0.50))

	RETURN CONCAT('You have to update ', @count, ' grades for the student ', (SELECT [FirstName] FROM [Students] WHERE [Id] = @studentId))
END
GO

-- Task 12
CREATE OR ALTER PROCEDURE usp_ExcludeFromSchool (@StudentId INT)
AS
	IF (SELECT [Id] FROM [Students] WHERE [Id] = @studentId) IS NULL
		RAISERROR ('This school has no student with the provided id!', 16, 1) 

	DELETE [StudentsSubjects]
	 WHERE [StudentId] = @StudentId

	 DELETE [StudentsExams]
	 WHERE [StudentId] = @StudentId

	 DELETE [StudentsTeachers]
	 WHERE [StudentId] = @StudentId

	DELETE [Students]
	 WHERE [Id] = @StudentId
GO

EXEC usp_ExcludeFromSchool 1

SELECT COUNT(*) FROM Students