USE StockSystem;

GO

CREATE TYPE dbo.StockItemPriceWorkingDate
AS TABLE
(
 StockItemPriceId		INT,
 StockItemId			INT,
 ItemPrice				MONEY,
 StartDate				DATE,
 EndDate				DATE,
 PreviousStartDate		DATE,
 NextStartDate			DATE,
 PreviousEndDate		DATE,
 NextEndDate			DATE,
 PreviousItemPrice		MONEY,
 NextItemPrice			MONEY,
 RejectionReason		NVARCHAR(300)
);

GO