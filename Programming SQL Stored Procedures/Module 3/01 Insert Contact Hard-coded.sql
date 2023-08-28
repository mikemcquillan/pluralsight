USE Contacts;

GO

CREATE PROCEDURE dbo.InsertContact
AS
BEGIN;

DECLARE @FirstName				VARCHAR(40),
		@LastName				VARCHAR(40),
		@DateOfBirth			DATE,
		@AllowContactByPhone	BIT;

SELECT	@FirstName = 'Stan',
		@LastName = 'Laurel',
		@DateOfBirth = '1890-06-16',
		@AllowContactByPhone = 0;

INSERT INTO dbo.Contacts
	(FirstName, LastName, DateOfBirth, AllowContactByPhone)
VALUES
	(@FirstName, @LastName, @DateOfBirth, @AllowContactByPhone);

END;