USE StockSystem;

--DELETE dbo.StockItemPrice WHERE StockItemPriceId = 8694;

INSERT INTO dbo.StockItemPrice
	(StockItemId, ItemPrice, StartDate)
VALUES
	(1, 2, '2023-12-25'),
	(12, 5, '2023-10-01');

SELECT *
	FROM dbo.StockItemPrice
WHERE StockItemId IN (1, 12)
ORDER BY StockItemId ASC, StartDate ASC;