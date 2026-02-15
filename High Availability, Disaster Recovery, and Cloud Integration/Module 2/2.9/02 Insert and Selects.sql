INSERT INTO StockSystem.dbo.Customer (FirstName, LastName, IsActive)
VALUES ('Jane', 'Doe', 1);

SELECT *
FROM StockSystem.dbo.Customer
WHERE CustomerName = 'Jane Doe';

SELECT TOP 20 *
FROM StockSystem.dbo.OrderHeader
ORDER BY OrderHeaderId DESC;