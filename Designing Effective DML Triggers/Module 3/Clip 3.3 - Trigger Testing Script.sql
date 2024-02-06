USE StockSystem;

--BEGIN TRANSACTION;

UPDATE dbo.StockItemPrice
	SET ItemPrice = 22--,
		--StartDate = '1974-10-10',
		--EndDate = '1986-01-29'
--WHERE StockItemPriceId = 4444;
WHERE StockItemPriceId BETWEEN 100 AND 199;

--SELECT *
--	FROM dbo.StockItemPrice
--WHERE StockItemId = 100
--ORDER BY StockItemId ASC, StartDate ASC;

SELECT * FROM dbo.AuditLog;

--ROLLBACK TRANSACTION;