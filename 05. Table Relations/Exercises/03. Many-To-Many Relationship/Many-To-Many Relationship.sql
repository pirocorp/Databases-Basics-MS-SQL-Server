CREATE TABLE Students(
	StudentID INT IDENTITY,
	[Name] NVARCHAR(64) NOT NULL,

	CONSTRAINT PK_Students
	PRIMARY KEY(StudentID),
)

CREATE TABLE Exams(
	ExamID INT,
	[Name] NVARCHAR(64) NOT NULL,

	CONSTRAINT PK_Exams
	PRIMARY KEY(ExamID),
)

CREATE TABLE StudentsExams(
	StudentID INT,
	ExamID INT,

	CONSTRAINT PK_StudentsExams
	PRIMARY KEY(StudentID, ExamID),

	CONSTRAINT FK_StudentsExams_Students
	FOREIGN KEY(StudentID)
	REFERENCES Students(StudentID),

	CONSTRAINT FK_StudentsExams_Exams
	FOREIGN KEY(ExamID)
	REFERENCES Exams(ExamID)
)

INSERT INTO Students
VALUES ('Mila'),
       ('Toni'),
	   ('Ron')

INSERT INTO Exams
VALUES (101, 'SpringMVC'),
       (102, 'Neo4j'),
	   (103, 'Oracle 11g')

INSERT INTO StudentsExams
VALUES (1,	101),
       (1,	102),
	   (2,	101),       
	   (3,	103),
	   (2,	102),       
	   (2,	103)
	   
SELECT * 
  FROM Students

SELECT * 
  FROM Exams

SELECT * 
  FROM StudentsExams