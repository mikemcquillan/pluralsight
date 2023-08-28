USE Contacts;

DROP PROCEDURE IF EXISTS dbo.InsertContact;

GO

CREATE PROCEDURE dbo.InsertContact
(
 @FirstName				VARCHAR(40),
 @LastName				VARCHAR(40),
 @DateOfBirth			DATE = NULL,
 @AllowContactByPhone	BIT
)
AS
BEGIN;

INSERT INTO dbo.Contacts
	(FirstName, LastName, DateOfBirth, AllowContactByPhone)
VALUES
	(@FirstName, @LastName, @DateOfBirth, @AllowContactByPhone);

END;