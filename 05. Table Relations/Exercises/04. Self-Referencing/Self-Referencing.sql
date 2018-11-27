CREATE TABLE Teachers(
	TeacherID INT,
	[Name] NVARCHAR(64) NOT NULL,
	ManagerID INT

	CONSTRAINT PK_Teachers
	PRIMARY KEY(TeacherID),

	CONSTRAINT FK_Teachers_ManagerID_Teachers_TeacherID
	FOREIGN KEY(ManagerID)
	REFERENCES Teachers(TeacherID),
)

INSERT INTO Teachers
VALUES (101, 'John', NULL),
       (102, 'Maya', 106),
       (103, 'Silvia', 106),
	   (104, 'Ted',	105),
	   (105, 'Mark', 101),
	   (106, 'Greta', 101)

SELECT * 
  FROM Teachers