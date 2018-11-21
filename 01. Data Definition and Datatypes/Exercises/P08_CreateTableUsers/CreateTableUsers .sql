CREATE TABLE Users(
	Id BIGINT PRIMARY KEY IDENTITY,
	Username VARCHAR(30) NOT NULL UNIQUE,
	[Password] VARCHAR(26) NOT NULL,
	ProfilPicture VARBINARY(900),
	LastLoginTime DATETIME,
	IsDeleted BIT DEFAULT(0) NOT NULL,
)

INSERT INTO Users(Username, [Password])
VALUES('pirocorp', 'kalkuta')

INSERT INTO Users(Username, [Password])
VALUES('piroman', '12345')

INSERT INTO Users(Username, [Password])
VALUES('abv', 'abv')

INSERT INTO Users(Username, [Password])
VALUES('12345', '12345')

INSERT INTO Users(Username, [Password])
VALUES('guest', 'guest')