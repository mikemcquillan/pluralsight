USE StockSystem;

--BEGIN TRANSACTION;

UPDATE dbo.StockItemPrice SET ItemPrice = 10 WHERE StockItemId = 100;

DELETE FROM dbo.StockItemPrice WHERE StockItemId = 100;

SELECT *
	FROM dbo.StockItemPrice
WHERE StockItemId = 100
ORDER BY StockItemId ASC, StartDate ASC;

SELECT * FROM dbo.AuditLog;

--ROLLBACK TRANSACTION;