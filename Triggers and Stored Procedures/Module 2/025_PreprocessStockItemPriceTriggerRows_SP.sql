USE StockSystem;

GO

IF EXISTS (SELECT 1 FROM sys.procedures WHERE [name] = 'StockItemPreprocessPriceTriggerRows')
 BEGIN;
	DROP PROCEDURE dbo.StockItemPreprocessPriceTriggerRows;
 END;

GO

CREATE PROCEDURE dbo.StockItemPreprocessPriceTriggerRows
(
 @RowsToProcess		dbo.StockItemPricePreProcessDate READONLY,
 @ActiveDates		dbo.StockItemPricePreProcessDate READONLY
)
AS
BEGIN;

SET NOCOUNT ON;

DECLARE @TempRowsToProcess	dbo.StockItemPricePreProcessDate,
		@AuditLog			dbo.AuditLogEntry;

-- Store data in a temporary table, so it can be edited
INSERT INTO @TempRowsToProcess
	(StockItemPriceId, StockItemId, ItemPrice, StartDate, EndDate, RejectionReason)
SELECT	StockItemPriceId, 
		StockItemId, 
		ItemPrice, 
		StartDate, 
		EndDate, 
		RejectionReason
	FROM @RowsToProcess;

/***** CALCULATE REJECTIONS *****/

-- Reject rows when start date is before current active start date
UPDATE RP
	SET RP.RejectionReason = 'Stock Item ID: ' + CONVERT(VARCHAR(10), RP.StockItemId) + ': Start date before current active start date.'
	FROM @TempRowsToProcess RP
		INNER JOIN @ActiveDates AD
			ON RP.StockItemId = AD.StockItemId
WHERE RP.StartDate < AD.StartDate
	AND RP.RejectionReason IS NULL;

-- Reject rows when the INSERT specifies the same start date multiple times
UPDATE RP
	SET RP.RejectionReason = 'Stock Item ID: ' + CONVERT(VARCHAR(10), RP.StockItemId) + ': Start date for item has been specified multiple times.'
	FROM @TempRowsToProcess RP
		INNER JOIN @ActiveDates AD
			ON RP.StockItemId = AD.StockItemId
WHERE RP.StockItemId IN
(
 SELECT	RP.StockItemId
	FROM @TempRowsToProcess RP
 GROUP BY RP.StockItemId, RP.StartDate HAVING COUNT(*) > 1
)
AND RP.StartDate IN
(
 SELECT	RP.StartDate
	FROM @TempRowsToProcess RP
 GROUP BY RP.StockItemId, RP.StartDate HAVING COUNT(*) > 1
)
AND RP.RejectionReason IS NULL;

-- Reject rows if the price specified is the current active price
UPDATE RP
	SET RP.RejectionReason = 'Stock Item ID: ' + CONVERT(VARCHAR(10), RP.StockItemId) + ': Specified price is already active.'
	FROM @TempRowsToProcess RP
		INNER JOIN @ActiveDates AD
			ON RP.StockItemId = AD.StockItemId
WHERE (RP.StartDate > AD.StartDate)
	AND RP.ItemPrice = AD.ItemPrice
	AND RP.RejectionReason IS NULL;

-- Reject rows in which the specified end date is earlier than the start datee
UPDATE RP
	SET RP.RejectionReason = 'Stock Item ID: ' + CONVERT(VARCHAR(10), RP.StockItemId) + ': End date is earlier than the start date.'
FROM @TempRowsToProcess RP
WHERE RP.EndDate < RP.StartDate
	AND RP.RejectionReason IS NULL;

-- Reject rows which specify a price at zero or lower
UPDATE RP
	SET RP.RejectionReason = 'Stock Item ID: ' + CONVERT(VARCHAR(10), RP.StockItemId) + ': Price must be higher than zero.'
FROM @TempRowsToProcess RP
WHERE RP.ItemPrice <= 0
	AND RP.RejectionReason IS NULL;

-- Reject rows in which the specified stock item ID does not exist
UPDATE RP
	SET RP.RejectionReason = 'Stock Item ID: ' + CONVERT(VARCHAR(10), RP.StockItemId) + ': Specified stock item ID does not exist.'
FROM @TempRowsToProcess RP
	LEFT JOIN dbo.StockItem SI
		ON RP.StockItemId = SI.StockItemId
WHERE SI.StockItemId IS NULL
	AND RP.RejectionReason IS NULL;

UPDATE RP
	SET RP.RejectionReason = 'Stock Item ID: ' + CONVERT(VARCHAR(10), RP.StockItemId) + ': Start Date, End Date and Item Price combination already exist.'
FROM @TempRowsToProcess RP
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
				(SELECT DISTINCT StockItemId FROM @TempRowsToProcess) RP
					ON SIP.StockItemId = RP.StockItemId
	UNION ALL
	SELECT RP.StockItemPriceId, RP.StockItemId, RP.ItemPrice, RP.StartDate, RP.EndDate
		FROM @TempRowsToProcess RP
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
			WHEN COALESCE(WD.EndDate, GETDATE()) >= DATEADD(d, -1, WD.NextStartDate)
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

INSERT INTO @AuditLog
	(RecordType, RecordId, ChangeNotes, UpdatedDate, UpdatedBy)
SELECT	'StockItemPrice',
		StockItemPriceId,
		RejectionReason,
		GETDATE(),
		USER_NAME()
	FROM @RowsToProcess
WHERE RejectionReason IS NOT NULL
UNION
SELECT	'StockItemPrice',
		StockItemPriceId,
		RejectionReason,
		GETDATE(),
		USER_NAME()
	FROM #WorkingDates
WHERE RejectionReason IS NOT NULL;

EXEC dbo.InsertAuditLogEntries
	@AuditLogEntries = @AuditLog;

/***** END OF INSERT AUDIT LOG RECORDS *****/

/***** RETURN PREPARED DATA *****/

SELECT	StockItemPriceId,
		StockItemId,
		ItemPrice,
		StartDate,
		EndDate,
		PreviousStartDate,
		NextStartDate,
		PreviousEndDate,
		NextEndDate,
		PreviousItemPrice,
		NextItemPrice,
		RejectionReason
FROM #WorkingDates;

/***** END OF RETURN PREPARED DATA *****/

SET NOCOUNT OFF;

END;

GO