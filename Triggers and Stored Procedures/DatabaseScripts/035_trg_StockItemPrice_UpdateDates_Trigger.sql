USE StockSystem;

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

/**** PRE-PROCESS DATA *****/

-- Store all rows in a temporary table, with a rejection reason column to capture rejections
-- We only want inserted rows, as updates and deletes will be rejected
SELECT	I.StockItemPriceId,
		I.StockItemId,
		I.ItemPrice,
		I.StartDate,
		I.EndDate,
		CONVERT(NVARCHAR(300), NULL) AS RejectionReason
INTO #RowsToProcess
	FROM inserted I
		LEFT JOIN deleted D
			ON I.StockItemPriceId = D.StockItemPriceId
WHERE D.StockItemPriceId IS NULL;

-- Obtain current active rows for INSERTs
SELECT	DISTINCT 
		SIP.StockItemPriceId,
		SIP.StockItemId,
		SIP.ItemPrice,
		SIP.StartDate,
		SIP.EndDate
INTO #ActiveDates
	FROM dbo.StockItemPrice SIP
		INNER JOIN inserted I
			ON SIP.StockItemId = I.StockItemId
WHERE CONVERT(DATE, GETDATE()) BETWEEN SIP.StartDate AND COALESCE(SIP.EndDate, CONVERT(DATE, GETDATE()));

/***** END OF PRE-PROCESS DATA *****/

/***** CALCULATE REJECTIONS *****/

-- Reject rows when start date is before current active start date
UPDATE RP
	SET RP.RejectionReason = 'Stock Item ID: ' + CONVERT(VARCHAR(10), RP.StockItemId) + ': Start date before current active start date.'
	FROM #RowsToProcess RP
		INNER JOIN #ActiveDates AD
			ON RP.StockItemId = AD.StockItemId
WHERE RP.StartDate < AD.StartDate
	AND RP.RejectionReason IS NULL;

-- Reject rows when the INSERT specifies the same start date multiple times
UPDATE RP
	SET RP.RejectionReason = 'Stock Item ID: ' + CONVERT(VARCHAR(10), RP.StockItemId) + ': Start date for item has been specified multiple times.'
	FROM #RowsToProcess RP
		INNER JOIN #ActiveDates AD
			ON RP.StockItemId = AD.StockItemId
WHERE RP.StockItemId IN
(
 SELECT	RP.StockItemId
	FROM #RowsToProcess RP
 GROUP BY RP.StockItemId, RP.StartDate HAVING COUNT(*) > 1
)
AND RP.StartDate IN
(
 SELECT	RP.StartDate
	FROM #RowsToProcess RP
 GROUP BY RP.StockItemId, RP.StartDate HAVING COUNT(*) > 1
)
AND RP.RejectionReason IS NULL;

-- Reject rows if the price specified is the current active price
UPDATE RP
	SET RP.RejectionReason = 'Stock Item ID: ' + CONVERT(VARCHAR(10), RP.StockItemId) + ': Specified price is already active.'
	FROM #RowsToProcess RP
		INNER JOIN #ActiveDates AD
			ON RP.StockItemId = AD.StockItemId
WHERE (RP.StartDate > AD.StartDate)
	AND RP.ItemPrice = AD.ItemPrice
	AND RP.RejectionReason IS NULL;

-- Reject rows in which the specified end date is earlier than the start datee
UPDATE RP
	SET RP.RejectionReason = 'Stock Item ID: ' + CONVERT(VARCHAR(10), RP.StockItemId) + ': End date is earlier than the start date.'
FROM #RowsToProcess RP
WHERE RP.EndDate < RP.StartDate
	AND RP.RejectionReason IS NULL;

-- Reject rows which specify a price at zero or lower
UPDATE RP
	SET RP.RejectionReason = 'Stock Item ID: ' + CONVERT(VARCHAR(10), RP.StockItemId) + ': Price must be higher than zero.'
FROM #RowsToProcess RP
WHERE RP.ItemPrice <= 0
	AND RP.RejectionReason IS NULL;

-- Reject rows in which the specified stock item ID does not exist
UPDATE RP
	SET RP.RejectionReason = 'Stock Item ID: ' + CONVERT(VARCHAR(10), RP.StockItemId) + ': Specified stock item ID does not exist.'
FROM #RowsToProcess RP
	LEFT JOIN dbo.StockItem SI
		ON RP.StockItemId = SI.StockItemId
WHERE SI.StockItemId IS NULL
	AND RP.RejectionReason IS NULL;

UPDATE RP
	SET RP.RejectionReason = 'Stock Item ID: ' + CONVERT(VARCHAR(10), RP.StockItemId) + ': Start Date, End Date and Item Price combination already exist.'
FROM #RowsToProcess RP
	INNER JOIN dbo.StockItemPrice SIP
		ON RP.StockItemId = SIP.StockItemId
			AND RP.StartDate = SIP.StartDate
			AND RP.EndDate = SIP.EndDate
			AND RP.ItemPrice = SIP.ItemPrice;

/***** END OF CALCULATE REJECTIONS *****/

/***** PREPARE WORKING SET OF DATA *****/

-- Create working set of data so correct dates can be calculated
WITH AllDates (StockItemPriceId, StockItemId, ItemPrice, StartDate, EndDate)
AS
(
	SELECT SIP.StockItemPriceId, SIP.StockItemId, SIP.ItemPrice, SIP.StartDate, SIP.EndDate
		FROM dbo.StockItemPrice SIP
			INNER JOIN 
				(SELECT DISTINCT StockItemId FROM #RowsToProcess) RP
					ON SIP.StockItemId = RP.StockItemId
	UNION ALL
	SELECT RP.StockItemPriceId, RP.StockItemId, RP.ItemPrice, RP.StartDate, RP.EndDate
		FROM #RowsToProcess RP
	WHERE RP.RejectionReason IS NULL
)
SELECT	StockItemPriceId,
		StockItemId,
		ItemPrice,
		StartDate,
		EndDate,
		LAG(StartDate, 1) OVER (ORDER BY StockItemId ASC, StartDate ASC, StockItemPriceId DESC) AS PreviousStartDate, 
		LEAD(StartDate, 1) OVER (ORDER BY StockItemId ASC, StartDate ASC, StockItemPriceId DESC) AS NextStartDate,
		LAG(EndDate, 1) OVER (ORDER BY StockItemId ASC, StartDate ASC, StockItemPriceId DESC) AS PreviousEndDate, 
		LEAD(EndDate, 1) OVER (ORDER BY StockItemId ASC, StartDate ASC, StockItemPriceId DESC) AS NextEndDate,
		LAG(ItemPrice, 1) OVER (ORDER BY StockItemId ASC, StartDate ASC, StockItemPriceId DESC) AS PreviousItemPrice,
		LEAD(ItemPrice, 1) OVER (ORDER BY StockItemId ASC, StartDate ASC, StockItemPriceId DESC) AS NextItemPrice,
		CONVERT(NVARCHAR(300), NULL) AS RejectionReason
INTO #WorkingDates
FROM AllDates
ORDER BY StockItemId ASC, StartDate ASC, StockItemPriceId DESC;

-- Update the working set, including any rejections because the price hasn't changed from row to row for future dates
UPDATE WD
	SET WD.EndDate = 
		CASE
			WHEN COALESCE(WD.EndDate, CONVERT(DATE, GETDATE())) >= DATEADD(d, -1, WD.NextStartDate)
				AND WD.StartDate <= DATEADD(d, -1, WD.NextStartDate) THEN DATEADD(d, -1, WD.NextStartDate)
			WHEN WD.EndDate IS NULL AND WD.NextStartDate IS NOT NULL AND WD.ItemPrice != WD.NextItemPrice 
				AND WD.NextStartDate >= WD.EndDate THEN DATEADD(d, -1, WD.NextStartDate)
			WHEN WD.EndDate IS NULL AND WD.NextEndDate IS NOT NULL AND WD.ItemPrice = WD.NextItemPrice 
				AND WD.NextEndDate >= WD.EndDate THEN WD.NextEndDate
			WHEN WD.NextEndDate IS NULL AND (DATEDIFF(d, EndDate, NextStartDate) - 1) > 1 
				AND WD.NextEndDate >= DATEADD(d, -1, WD.NextStartDate) THEN DATEADD(d, -1, WD.NextStartDate)
			WHEN WD.EndDate IS NOT NULL AND WD.NextEndDate IS NULL AND WD.ItemPrice = WD.NextItemPrice
				THEN NULL
			WHEN WD.NextStartDate > WD.EndDate THEN DATEADD(d, -1, WD.NextStartDate)
			ELSE WD.EndDate
		END,
		WD.RejectionReason = 
			CASE
				WHEN WD.PreviousEndDate IS NULL AND WD.ItemPrice = WD.PreviousItemPrice 
					THEN 'Stock Item ID: ' + CONVERT(VARCHAR(10), WD.StockItemId) + ': Price is same as previous row.'
				WHEN WD.StartDate <= WD.PreviousStartDate AND WD.EndDate <= WD.PreviousEndDate
						AND WD.ItemPrice = WD.PreviousItemPrice
					THEN 'Stock Item ID: ' + CONVERT(VARCHAR(10), WD.StockItemId) + ': Price is same as previous row.'
				WHEN WD.StockItemPriceId = 0 AND WD.EndDate IS NULL AND WD.PreviousEndDate IS NOT NULL
						AND WD.ItemPrice = WD.PreviousItemPrice
					THEN 'Stock Item ID: ' + CONVERT(VARCHAR(10), WD.StockItemId) + ': Price is same as previous row, but will switch previous row''s end date to NULL.'
				ELSE NULL
			END
FROM #WorkingDates WD;

/***** END OF PREPARE WORKING SET OF DATA *****/

/***** INSERT AUDIT LOG RECORDS *****/

INSERT INTO dbo.AuditLog
	(RecordType, RecordId, ChangeNotes, UpdatedDate, UpdatedBy)
SELECT	'StockItemPrice',
		StockItemPriceId,
		RejectionReason,
		GETDATE(),
		USER_NAME()
	FROM #RowsToProcess
WHERE RejectionReason IS NOT NULL
UNION
SELECT	'StockItemPrice',
		StockItemPriceId,
		RejectionReason,
		GETDATE(),
		USER_NAME()
	FROM #WorkingDates
WHERE RejectionReason IS NOT NULL
UNION
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
		FROM #WorkingDates
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