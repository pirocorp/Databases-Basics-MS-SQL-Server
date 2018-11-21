--Drop Constraint
ALTER TABLE Users
DROP CONSTRAINT PK_Id_Username

--Make Id Primary Key
ALTER TABLE Users
ADD CONSTRAINT PK_Id
PRIMARY KEY(Id)

--Remove old unique contraint on Username
ALTER TABLE Users
DROP CONSTRAINT UQ__Users__536C85E48D30131B 

--Add unique constraint for username
ALTER TABLE Users
ADD CONSTRAINT uq_Username
UNIQUE(Username)

--Add at least 3 symbols long constraint for Username
ALTER TABLE Users
ADD CONSTRAINT atLeastTreeSymbolsLong_Username
CHECK(LEN(Username) >= 3)