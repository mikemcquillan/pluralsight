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
ALTER TRIGGER trg_StockItemPrice_UpdateDates
ON dbo.StockItemPrice
INSTEAD OF INSERT, UPDATE, DELETE
AS
BEGIN;

IF (@@ROWCOUNT = 0) RETURN;
IF NOT EXISTS (SELECT 1 FROM inserted UNION ALL SELECT 1 FROM deleted) RETURN;

SET NOCOUNT ON;

--DECLARE @RowsToReject		TABLE (StockItemPriceId INT, StockItemId INT, ItemPrice MONEY, StartDate DATE, EndDate DATE, Reason NVARCHAR(300));

-- Store all rows in a temporary table, with a rejection reason column to capture rejections
SELECT *, CONVERT(NVARCHAR(300), NULL) AS RejectionReason
INTO #RowsToProcess
	FROM inserted;

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
WHERE GETDATE() BETWEEN SIP.StartDate AND COALESCE(SIP.EndDate, GETDATE());

/***** CALCULATE REJECTIONS *****/

-- Reject rows when start date is before current active start date
UPDATE RP
	SET RP.RejectionReason = 'Start date before current active start date'
	FROM #RowsToProcess RP
		INNER JOIN #ActiveDates AD
			ON RP.StockItemId = AD.StockItemId
WHERE RP.StartDate < AD.StartDate
	AND RP.RejectionReason IS NULL;

-- Reject rows when the INSERT specifies the same start date multiple times
UPDATE RP
	SET RP.RejectionReason = 'Start date for item has been specified multiple times'
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
	SET RP.RejectionReason = 'Price is already active'
	FROM #RowsToProcess RP
		INNER JOIN #ActiveDates AD
			ON RP.StockItemId = AD.StockItemId
WHERE (RP.StartDate > AD.StartDate)
	AND RP.ItemPrice = AD.ItemPrice
	AND RP.RejectionReason IS NULL;

-- Reject rows in which the specified end date is earlier than the start datee
UPDATE RP
	SET RP.RejectionReason = 'End date is earlier than the start date.'
FROM #RowsToProcess RP
WHERE RP.EndDate < RP.StartDate
	AND RP.RejectionReason IS NULL;

-- Reject rows which specify a price at zero or lower
UPDATE RP
	SET RP.RejectionReason = 'Price must be higher than zero.'
FROM #RowsToProcess RP
WHERE RP.ItemPrice <= 0
	AND RP.RejectionReason IS NULL;

-- Reject rows in which the specified stock item ID does not exist
UPDATE RP
	SET RP.RejectionReason = 'Specified stock item ID does not exist'
FROM #RowsToProcess RP
	LEFT JOIN dbo.StockItem SI
		ON RP.StockItemId = SI.StockItemId
WHERE SI.StockItemId IS NULL
	AND RP.RejectionReason IS NULL;

/***** END OF CALCULATE REJECTIONS *****/

-- Create working set of data so correct dates can be calculated
WITH AllDates (StockItemPriceId, StockItemId, ItemPrice, StartDate, EndDate, IsExisting)
AS
(
	SELECT SIP.StockItemPriceId, SIP.StockItemId, SIP.ItemPrice, SIP.StartDate, SIP.EndDate, 1 AS IsExisting
		FROM dbo.StockItemPrice SIP
			INNER JOIN 
				(SELECT DISTINCT StockItemId FROM #RowsToProcess) RP
					ON SIP.StockItemId = RP.StockItemId
	UNION ALL
	SELECT RP.StockItemPriceId, RP.StockItemId, RP.ItemPrice, RP.StartDate, RP.EndDate, 0 AS IsExisting
		FROM #RowsToProcess RP
	WHERE RP.RejectionReason IS NULL
)
SELECT	*, 
		LAG(StartDate, 1) OVER (ORDER BY StartDate) AS PreviousStartDate, 
		LEAD(StartDate, 1) OVER (ORDER BY StartDate) AS NextStartDate,
		LAG(EndDate, 1) OVER (ORDER BY StartDate) AS PreviousEndDate, 
		LEAD(EndDate, 1) OVER (ORDER BY StartDate) AS NextEndDate,
		LAG(ItemPrice, 1) OVER (ORDER BY StartDate) AS PreviousItemPrice,
		LEAD(ItemPrice, 1) OVER (ORDER BY StartDate) AS NextItemPrice,
		CONVERT(NVARCHAR(300), NULL) AS RejectionReason
INTO #WorkingDates
FROM AllDates
ORDER BY StockItemId ASC, StartDate ASC;

-- Update the working set, including any rejections because the price hasn't changed from row to row for future dates
UPDATE WD
	SET WD.EndDate = 
		CASE
			WHEN COALESCE(WD.EndDate, GETDATE()) > WD.NextStartDate THEN DATEADD(d, -1, WD.NextStartDate) -- 'Update end date'
			WHEN WD.EndDate IS NULL AND WD.NextStartDate IS NOT NULL AND WD.ItemPrice != WD.NextItemPrice THEN DATEADD(d, -1, WD.NextStartDate) -- 'Update end date 2'
			WHEN WD.EndDate IS NULL AND WD.NextEndDate IS NOT NULL AND WD.ItemPrice = WD.NextItemPrice THEN WD.NextEndDate
			ELSE WD.EndDate
		END,
		WD.RejectionReason = 
			CASE
				WHEN WD.PreviousEndDate IS NULL AND WD.ItemPrice = WD.PreviousItemPrice THEN 'Price is same as previous row'
				ELSE NULL
			END
FROM #WorkingDates WD;

--SELECT * FROM #RowsToProcess WHERE RejectionReason IS NOT NULL;
SELECT * FROM #WorkingDates;

-- TODO:
-- INSERT rejection rows from RowsToProcess into audit trail
-- INSERT rejection rows from WorkingDates into audit trail
-- Log UPDATE attempts into audit trail, as updates are not allowed
-- Log DELETE attempts into audit trail, as deletes are not allowed
-- DELETE rejection rows from WorkingDates
-- UPDATE and INSERT rejection rows into StockItemPrice

SET NOCOUNT OFF;

END;