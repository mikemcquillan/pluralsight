USE StockSystem;

GO

CREATE TRIGGER trg_StockItemPrice_After
ON dbo.StockItemPrice
AFTER INSERT
AS
BEGIN;

SELECT * FROM inserted;

END;