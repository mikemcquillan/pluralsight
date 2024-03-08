USE StockSystem;

GO

CREATE TYPE dbo.StockItemPricePreProcessDate
AS TABLE
(
 StockItemPriceId		INT,
 StockItemId			INT,
 ItemPrice				MONEY,
 StartDate				DATE,
 EndDate				DATE,
 RejectionReason		NVARCHAR(300)
);

GO