CREATE TABLE Majors(
	MajorID INT IDENTITY,
	[Name] VARCHAR(50) NOT NULL,

	CONSTRAINT PK_Majors
	PRIMARY KEY(MajorID),
)

CREATE TABLE Subjects(
	SubjectID INT IDENTITY,
	[SubjectName] VARCHAR(50) NOT NULL,

	CONSTRAINT PK_Subjects
	PRIMARY KEY(SubjectID),
)

CREATE TABLE Students(
	StudentID INT IDENTITY,
	StudentNumber VARCHAR(50) NOT NULL,
	[SubjectName] VARCHAR(50) NOT NULL,
	MajorID INT,

	CONSTRAINT PK_Students
	PRIMARY KEY(StudentID),

	CONSTRAINT FK_Students_MajorID_Majors_MajorID
	FOREIGN KEY(MajorID)
	REFERENCES Majors(MajorID),
)

CREATE TABLE Agenda(
	StudentID INT,
	SubjectID INT,

	CONSTRAINT PK_Agenda
	PRIMARY KEY(StudentID, SubjectID),

	CONSTRAINT FK_StudentsExams_StudentID_Students_StudentID
	FOREIGN KEY(StudentID)
	REFERENCES Students(StudentID),

	CONSTRAINT FK_StudentsExams_SubjectID_Subjects_SubjectID
	FOREIGN KEY(SubjectID)
	REFERENCES Subjects(SubjectID)
)

CREATE TABLE Payments(
	PaymentID INT IDENTITY,
	PaymentDate DATE,
	PaymentAmount DECIMAL(10, 2),
	StudentID INT,

	CONSTRAINT PK_Payments
	PRIMARY KEY(PaymentID),

	CONSTRAINT FK_Payments_StudentID_Students_StudentID
	FOREIGN KEY(StudentID)
	REFERENCES Students(StudentID),
)