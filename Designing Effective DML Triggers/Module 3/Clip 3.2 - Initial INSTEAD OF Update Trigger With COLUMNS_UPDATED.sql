USE StockSystem;

GO

-- Trigger executes if a user tries to update a stock item price row
-- Rows cannot be modified, they can only be inserted
CREATE TRIGGER trg_StockItemPrice_PreventUpdates
ON dbo.StockItemPrice
INSTEAD OF UPDATE
AS
BEGIN;

IF (@@ROWCOUNT = 0) RETURN;
IF NOT EXISTS (SELECT 1 FROM inserted UNION ALL SELECT 1 FROM deleted) RETURN;

SET NOCOUNT ON;

IF (COLUMNS_UPDATED() & 4) > 0
 BEGIN;
	PRINT 'User attempted to update the ItemPrice column';
 END;

IF (COLUMNS_UPDATED() & 8) > 0
 BEGIN;
	PRINT 'User attempted to update the StartDate column';
 END;

IF (COLUMNS_UPDATED() & 16) > 0
 BEGIN;
	PRINT 'User attempted to update the EndDate column';
 END;

IF (COLUMNS_UPDATED() & 28) = 28
 BEGIN;
	PRINT 'User attempted to update the ItemPrice, StartDate and EndDate columns';
 END;

SELECT * FROM inserted;
SELECT * FROM deleted;

SET NOCOUNT OFF;

END;