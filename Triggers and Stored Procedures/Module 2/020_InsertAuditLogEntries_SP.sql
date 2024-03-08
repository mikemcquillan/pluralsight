USE StockSystem;

GO

CREATE PROCEDURE dbo.InsertAuditLogEntries
(
 @AuditLogEntries		dbo.AuditLogEntry READONLY
)
AS
BEGIN;

SET NOCOUNT ON;

BEGIN TRY;

	BEGIN TRANSACTION;

	select 1/0;

	INSERT INTO dbo.AuditLog
		(RecordType, RecordId, ChangeNotes, UpdatedDate, UpdatedBy)
	SELECT	RecordType,
			RecordId,
			ChangeNotes,
			UpdatedDate,
			UpdatedBy
		FROM @AuditLogEntries;

	COMMIT TRANSACTION;

END TRY
BEGIN CATCH;
	IF (@@TRANCOUNT > 0)
	 BEGIN;
		PRINT 'Rolling back in InsertAuditLogEntries stored procedure';
		ROLLBACK TRANSACTION;
	 END;
END CATCH;

SET NOCOUNT OFF;

END;

GO