USE StockSystem;

GO

CREATE TABLE dbo.StockItem
(
 StockItemId	INT IDENTITY(1,1)	NOT NULL,
 Title			NVARCHAR(100)		NULL,
 [Format]		NVARCHAR(50)		NULL,
 Publisher		NVARCHAR(50)		NULL,
 Media			NVARCHAR(50)		NULL,
 YearReleased	SMALLINT			NULL,
 Condition		NVARCHAR(50)		NULL,
 ReleaseType	NVARCHAR(50)		NULL,
 ItemType		NVARCHAR(50)		NULL,
 [Case]			NVARCHAR(50)		NULL,
 [Description]	NVARCHAR(150)		NULL,
 ItemCode		VARCHAR(15)			NULL,
 StockLevel		INT					NULL,
 BasePrice		MONEY				NOT NULL,
 CONSTRAINT pk_StockItem PRIMARY KEY CLUSTERED (StockItemId)
) 
ON [PRIMARY];

GO


