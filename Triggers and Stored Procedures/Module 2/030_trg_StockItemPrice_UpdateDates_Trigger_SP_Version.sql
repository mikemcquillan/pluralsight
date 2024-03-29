USE StockSystem;

GO

IF EXISTS (SELECT 1 FROM sys.triggers procedures WHERE [name] = 'trg_StockItemPrice_UpdateDates')
 BEGIN;
	DROP TRIGGER trg_StockItemPrice_UpdateDates;
 END;

GO

-- Trigger to set correct dates after INSERT
-- RULES:
-- Reject rows when start date is before current active start date
-- Reject rows when the INSERT specifies the same start date multiple times
-- Reject rows if the price specified is the current active price
-- Reject rows in which the specified end date is earlier than the start date
-- Reject rows which specify a price at zero or lower
-- Reject rows in which the specified stock item ID does not exist
-- Reject rows when the row is the same as the previous row's price (the previous row may not be the current active price)
-- Reject rows which already exist based upon stock item ID, start date, end date and item price
CREATE TRIGGER trg_StockItemPrice_UpdateDates
ON dbo.StockItemPrice
INSTEAD OF INSERT, UPDATE, DELETE
AS
BEGIN;

IF (@@ROWCOUNT = 0) RETURN;
IF NOT EXISTS (SELECT 1 FROM inserted UNION ALL SELECT 1 FROM deleted) RETURN;

SET NOCOUNT ON;

DECLARE @RowsToProcess		dbo.StockItemPricePreProcessDate,
		@ActiveDates		dbo.StockItemPricePreProcessDate,
		@WorkingDates		dbo.StockItemPriceWorkingDate,
		@AuditLog			dbo.AuditLogEntry;

/**** PRE-PROCESS DATA *****/

-- Store all rows in a temporary table, with a rejection reason column to capture rejections
-- We only want inserted rows, as updates and deletes will be rejected
INSERT INTO @RowsToProcess
	(StockItemPriceId, StockItemId, ItemPrice, StartDate, EndDate, RejectionReason)
SELECT	I.StockItemPriceId,
		I.StockItemId,
		I.ItemPrice,
		I.StartDate,
		I.EndDate,
		CONVERT(NVARCHAR(300), NULL) AS RejectionReason
	FROM inserted I
		LEFT JOIN deleted D
			ON I.StockItemPriceId = D.StockItemPriceId
WHERE D.StockItemPriceId IS NULL;

-- Obtain current active rows for INSERTs
INSERT INTO @ActiveDates
	(StockItemPriceId, StockItemId, ItemPrice, StartDate, EndDate)
SELECT	DISTINCT 
		SIP.StockItemPriceId,
		SIP.StockItemId,
		SIP.ItemPrice,
		SIP.StartDate,
		SIP.EndDate
	FROM dbo.StockItemPrice SIP
		INNER JOIN inserted I
			ON SIP.StockItemId = I.StockItemId
WHERE CONVERT(DATE, GETDATE()) BETWEEN SIP.StartDate AND COALESCE(SIP.EndDate, CONVERT(DATE, GETDATE()));

/***** END OF PRE-PROCESS DATA *****/

/***** PREPARE WORKING SET OF DATA *****/

INSERT INTO @WorkingDates
	(StockItemPriceId, StockItemId, ItemPrice, StartDate, EndDate, PreviousStartDate, NextStartDate, 
	 PreviousEndDate, NextEndDate, PreviousItemPrice, NextItemPrice, RejectionReason)
EXEC dbo.StockItemPreprocessPriceTriggerRows
	@RowsToProcess = @RowsToProcess,
	@ActiveDates = @ActiveDates;

/***** END OF PREPARE WORKING SET OF DATA *****/

/***** INSERT AUDIT LOG RECORDS *****/

INSERT INTO @AuditLog
	(RecordType, RecordId, ChangeNotes, UpdatedDate, UpdatedBy)
SELECT	'StockItemPrice',
		I.StockItemPriceId,
		'Update attempted.',
		GETDATE(),
		USER_NAME()
	FROM inserted I
		INNER JOIN deleted D
			ON I.StockItemPriceId = D.StockItemPriceId
UNION
SELECT	'StockItemPrice',
		D.StockItemPriceId,
		'Delete attempted.',
		GETDATE(),
		USER_NAME()
	FROM deleted D
		LEFT JOIN inserted I
			ON D.StockItemPriceId = I.StockItemPriceId
WHERE I.StockItemPriceId IS NULL;

EXEC dbo.InsertAuditLogEntries
	@AuditLogEntries = @AuditLog;

/***** END OF INSERT AUDIT LOG RECORDS *****/

/***** INSERT OR UPDATE PREPARED DATA *****/

MERGE INTO dbo.StockItemPrice AS tgt
USING
	(
	 SELECT	StockItemPriceId,
			StockItemId,
			ItemPrice,
			StartDate,
			EndDate
		FROM @WorkingDates
	 WHERE RejectionReason IS NULL
	) AS src (StockItemPriceId, StockItemId, ItemPrice, StartDate, EndDate)
	ON tgt.StockItemPriceId = src.StockItemPriceId
WHEN MATCHED
	THEN UPDATE
		SET tgt.EndDate = src.EndDate
WHEN NOT MATCHED
	THEN INSERT
			(StockItemId, ItemPrice, StartDate, EndDate)
		VALUES
			(StockItemId, ItemPrice, StartDate, EndDate);

/***** END OF INSERT OR UPDATE PREPARED DATA *****/

SET NOCOUNT OFF;

END;

GO