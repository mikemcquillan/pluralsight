USE StockSystem;

INSERT INTO dbo.StockItemPrice
	(StockItemId, ItemPrice, StartDate)
VALUES
	(1, 2, '2023-09-16');

SELECT *
	FROM dbo.StockItemPrice
WHERE StockItemId = 1
ORDER BY StartDate ASC;