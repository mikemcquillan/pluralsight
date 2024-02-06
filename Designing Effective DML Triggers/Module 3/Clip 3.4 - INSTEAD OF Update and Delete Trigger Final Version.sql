USE StockSystem;

GO

-- Trigger executes if a user tries to update or delete a stock item price row
-- Rows cannot be modified, they can only be inserted
CREATE TRIGGER trg_StockItemPrice_PreventUpdatesAndDeletes
ON dbo.StockItemPrice
INSTEAD OF UPDATE, DELETE
AS
BEGIN;

IF (@@ROWCOUNT = 0) RETURN;
IF NOT EXISTS (SELECT 1 FROM inserted UNION ALL SELECT 1 FROM deleted) RETURN;

SET NOCOUNT ON;

IF ((SELECT COUNT(1) FROM inserted) > 0)
 BEGIN;
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
 END;

IF ((SELECT COUNT(1) FROM deleted D LEFT JOIN inserted I ON D.StockItemPriceId = I.StockItemPriceId
		WHERE I.StockItemPriceId IS NULL) > 0)
 BEGIN;
	INSERT INTO dbo.AuditLog
		(RecordType, RecordId, ChangeNotes, UpdatedDate, UpdatedBy)
	SELECT	'StockItemPrice',
			StockItemPriceId,
			'Deletion attempted',
			GETDATE(),
			USER_NAME()
	FROM deleted;
 END;

SET NOCOUNT OFF;

END;