USE StockSystem;

INSERT INTO dbo.StockItemPrice
	(StockItemId, ItemPrice, StartDate)
VALUES
	(1, 2, '2023-10-24');

--UPDATE dbo.StockItemPrice
--	SET StartDate = '2023-10-03'
--WHERE StockItemPriceId = 8689; -- 8690;

--DELETE dbo.StockItemPrice WHERE StockItemPriceId = 8689; --8690;

SELECT *
	FROM dbo.StockItemPrice
WHERE StockItemId = 1
ORDER BY StartDate ASC;

INSERT INTO dbo.StockItemPrice
	(StockItemId, ItemPrice, StartDate)
VALUES
	(1, 2, '2023-11-24'),
	(12, 5, '2023-10-01');

SELECT *
	FROM dbo.StockItemPrice
WHERE StockItemId IN (1, 12)
ORDER BY StockItemId ASC, StartDate ASC;