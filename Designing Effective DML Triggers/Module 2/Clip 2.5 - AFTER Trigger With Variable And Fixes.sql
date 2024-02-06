USE StockSystem;

GO

-- Trigger to set correct dates after INSERT
-- Sets old active row's end date, and correct dates for new active row
ALTER TRIGGER trg_StockitemPrice_UpdateDates
ON dbo.StockItemPrice
AFTER INSERT
AS
BEGIN;

DECLARE @OldStockItemPriceId	INT;

IF (@@ROWCOUNT = 0) RETURN;
IF NOT EXISTS (SELECT 1 FROM inserted) RETURN;

SET NOCOUNT ON;

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

SET NOCOUNT OFF;

END;