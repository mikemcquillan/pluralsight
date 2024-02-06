USE [StockSystem]

GO

CREATE TABLE dbo.AuditLog
(
 AuditLogId			INT IDENTITY(1,1)	NOT NULL,
 RecordType			NVARCHAR(25)		NOT NULL,
 RecordId			INT					NOT NULL,
 ChangeNotes		NVARCHAR(2000)		NOT NULL,
 UpdatedDate		DATETIME			NOT NULL,
 UpdatedBy			NVARCHAR(100)		NOT NULL,
 CONSTRAINT pk_AuditLog PRIMARY KEY CLUSTERED (AuditLogId)
) 
ON [PRIMARY];

GO


