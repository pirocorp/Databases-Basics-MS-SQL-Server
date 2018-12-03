--Transactions
--A Transaction is a sequence of actions (database operations) executed as a whole:
--Either all of them complete successfully or none of them do
--Transactions guarantee the consistency and the integrity of the database
--All changes in a transaction are temporary
--Changes are persisted when COMMIT is executed
--At any time, all changes can be canceled by ROLLBACK
--All changes are persisted at once
--As long as COMMIT is called
--Transactions Syntax
BEGIN TRANSACTION
UPDATE Accounts SET Balance = Balance - @withdrawAmount
WHERE Id = @accountId
IF @@ROWCOUNT <> 1 – Didn’t affect exactly one row
BEGIN
  ROLLBACK
  RAISERROR('Invalid account!', 16, 1)
  RETURN
END
COMMIT
GO

--ACID Model
--Atomicity - Transactions are all or nothing Transactions execute as a whole
	--DBMS guarantees that either all of theoperations are performed or none of them
--Consistency - Only valid data is saved The database has a legal state in both the transaction’s 
	--beginning and end Only valid data will be written to the DB Transaction cannot break the rules of
	--the database Primary keys, foreign keys, check constraints…
--Isolation - Transactions do not affect each other Multiple transactions running at the same time do 
	--not impact each other’s execution
	--Transactions don’t see othertransactions’ uncommitted changes
	--Isolation level defines how deeptransactions isolate from one another
--Durability - Written data will not be lost If a transaction is committed it becomes persistent
	--Cannot be lost or undone Ensured by use of database transaction logs

--Triggers - Triggers are very much like stored procedures. Called in case of specific event
--We do not call triggers explicitly
--Triggers are attached to a table.
--Triggers are fired when a certain SQL statement is executed against the contents of the table.
--Syntax:
--AFTER INSERT/UPDATE/DELETE
--INSTEAD OF INSERT/UPDATE/DELETE
--Defined by the keyword FOR
CREATE TRIGGER tr_TownsUpdate ON Towns FOR UPDATE
AS
  IF (EXISTS(
        SELECT * FROM inserted
        WHERE Name IS NULL OR LEN(Name) = 0))
  BEGIN
    RAISERROR('Town name cannot be empty.', 16, 1)
    ROLLBACK
    RETURN
  END

UPDATE Towns SET Name='' WHERE TownId=1
GO

--Instead Of Triggers
CREATE TRIGGER tr_AccountsDelete ON Accounts
INSTEAD OF DELETE
AS
UPDATE a SET Active = 'N'
  FROM Accounts AS a JOIN DELETED d 
    ON d.Username = a.Username
 WHERE a.Active = 'Y'  
 GO
