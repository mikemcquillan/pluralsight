USE StockSystem;

--DROP TRIGGER trg_StockItemPrice_After;

GO

ALTER TRIGGER trg_StockItemPrice_After
ON dbo.StockItemPrice
AFTER INSERT, UPDATE, DELETE
AS
BEGIN;

SELECT * FROM inserted;
SELECT * FROM deleted;

END;