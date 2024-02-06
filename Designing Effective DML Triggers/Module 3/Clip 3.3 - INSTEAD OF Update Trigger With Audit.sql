USE StockSystem;

GO

ALTER TRIGGER trg_StockItemPrice_PreventUpdates
ON dbo.StockItemPrice
INSTEAD OF UPDATE
AS
BEGIN;

IF (@@ROWCOUNT = 0) RETURN;
IF NOT EXISTS (SELECT 1 FROM inserted UNION ALL SELECT 1 FROM deleted) RETURN;

SET NOCOUNT ON;

INSERT INTO dbo.AuditLog
	(RecordType, RecordId, ChangeNotes, UpdatedDate, UpdatedBy)
SELECT	'StockItemPrice',
		StockItemPriceId,
		CASE
			WHEN (COLUMNS_UPDATED() & 28) = 28 THEN 'ItemPrice, StartDate and EndDate update attempted'
			WHEN (UPDATE(ItemPrice)) THEN 'ItemPrice update attempted'
			WHEN (UPDATE(StartDate)) THEN 'StartPrice update attempted'
			WHEN (UPDATE(EndDate)) THEN 'EndDate update attempted'
		END,
		GETDATE(),
		USER_NAME()
FROM inserted;

SET NOCOUNT OFF;

END;