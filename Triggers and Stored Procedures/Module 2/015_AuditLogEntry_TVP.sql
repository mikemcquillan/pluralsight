USE StockSystem;

GO

CREATE TYPE dbo.AuditLogEntry
AS TABLE
(
 RecordType				NVARCHAR(25),
 RecordId				INT,
 ChangeNotes			NVARCHAR(2000),
 UpdatedDate			DATETIME,
 UpdatedBy				NVARCHAR(100)
);

GO