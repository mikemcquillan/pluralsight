USE [StockSystem]
GO
/****** Object:  StoredProcedure [dbo].[InsertAuditLogEntries]    Script Date: 08/03/2024 10:23:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[InsertAuditLogEntries]
(
 @AuditLogEntries		dbo.AuditLogEntry READONLY
)
AS
BEGIN;

SET NOCOUNT ON;

BEGIN TRY;

	BEGIN TRANSACTION;

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

