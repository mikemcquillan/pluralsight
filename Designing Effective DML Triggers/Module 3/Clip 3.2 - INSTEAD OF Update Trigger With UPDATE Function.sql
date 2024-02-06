USE StockSystem;

GO

-- Trigger executes if a user tries to update a stock item price row
-- Rows cannot be modified, they can only be inserted
ALTER TRIGGER trg_StockItemPrice_PreventUpdates
ON dbo.StockItemPrice
INSTEAD OF UPDATE
AS
BEGIN;

IF (@@ROWCOUNT = 0) RETURN;
IF NOT EXISTS (SELECT 1 FROM inserted UNION ALL SELECT 1 FROM deleted) RETURN;

SET NOCOUNT ON;

IF (UPDATE(ItemPrice))
 BEGIN;
	PRINT 'User attempted to update the ItemPrice column';
 END;

IF (UPDATE(StartDate))
 BEGIN;
	PRINT 'User attempted to update the StartDate column';
 END;

IF (UPDATE(EndDate))
 BEGIN;
	PRINT 'User attempted to update the EndDate column';
 END;

IF (UPDATE(ItemPrice) AND UPDATE(StartDate) AND UPDATE(EndDate))
 BEGIN;
	PRINT 'User attempted to update the ItemPrice, StartDate and EndDate columns';
 END;

SELECT * FROM inserted;
SELECT * FROM deleted;

SET NOCOUNT OFF;

END;