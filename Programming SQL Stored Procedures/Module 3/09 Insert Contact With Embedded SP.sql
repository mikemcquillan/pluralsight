USE Contacts;

DROP PROCEDURE IF EXISTS dbo.InsertContact;

GO

CREATE PROCEDURE dbo.InsertContact
(
 @FirstName				VARCHAR(40),
 @LastName				VARCHAR(40),
 @DateOfBirth			DATE = NULL,
 @AllowContactByPhone	BIT,
 @ContactId				INT OUTPUT
)
AS
BEGIN;

SET NOCOUNT ON;

INSERT INTO dbo.Contacts
	(FirstName, LastName, DateOfBirth, AllowContactByPhone)
VALUES
	(@FirstName, @LastName, @DateOfBirth, @AllowContactByPhone);

SELECT @ContactId = SCOPE_IDENTITY();
EXEC dbo.SelectContact @ContactId = @ContactId;

SET NOCOUNT OFF;

END;