USE StockSystem;

INSERT INTO dbo.StockItemPrice
	(StockItemId, ItemPrice, StartDate)
VALUES
	(1, 2, '2023-09-16');

DECLARE @tvp	TABLE (StockItemId INT, ItemPrice MONEY, StartDate DATE);

INSERT INTO dbo.StockItemPrice (StockItemId, ItemPrice, StartDate)
	SELECT * FROM @tvp;

--UPDATE dbo.StockItemPrice
--	SET StartDate = '2023-10-03'
--WHERE StockItemPriceId = 8689; -- 8690;

--DELETE dbo.StockItemPrice WHERE StockItemPriceId = 8689; --8690;

SELECT *
	FROM dbo.StockItemPrice
WHERE StockItemId = 1
ORDER BY StartDate ASC;