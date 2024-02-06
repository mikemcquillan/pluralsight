USE StockSystem;

GO

CREATE TRIGGER trg_StockitemPrice_UpdateDates
ON dbo.StockItemPrice
AFTER INSERT
AS
BEGIN;

DECLARE @OldStockItemPriceId	INT;

SELECT @OldStockItemPriceId = SIP.StockItemPriceId
	FROM dbo.StockItemPrice SIP
		INNER JOIN inserted I
			ON SIP.StockItemId = I.StockItemId
WHERE SIP.EndDate IS NULL
	AND SIP.StockItemPriceId != I.StockItemPriceId;

SELECT *
	FROM dbo.StockItemPrice SIP
		INNER JOIN inserted I
			ON SIP.StockItemId = I.StockItemId
WHERE SIP.StockItemPriceId = @OldStockItemPriceId;

UPDATE SIP
	SET EndDate = DATEADD(d, -1, COALESCE(i.StartDate, GETDATE()))
FROM dbo.StockItemPrice SIP
	INNER JOIN inserted I
		ON SIP.StockItemId = I.StockItemId
WHERE SIP.StockItemPriceId = @OldStockItemPriceId;

UPDATE SIP
	SET StartDate = COALESCE(I.StartDate, GETDATE()),
		EndDate = NULL
FROM dbo.StockItemPrice SIP
	INNER JOIN inserted I
		ON SIP.StockItemPriceId = I.StockItemPriceId;

END;