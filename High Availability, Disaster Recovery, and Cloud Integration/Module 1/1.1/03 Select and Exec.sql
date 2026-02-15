USE StockSystem;

SELECT TOP 1 * FROM dbo.OrderHeader ORDER BY OrderHeaderID DESC;

EXEC dbo.CreateSampleOrders;