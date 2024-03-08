USE StockSystem;

INSERT INTO dbo.StockItemPrice
	(StockItemId, ItemPrice, StartDate, EndDate)
VALUES
	(99, 100, '2023-05-04', '2024-05-31'),				-- REJECT. Start date is before current start date.
	(99, 100, '2023-04-12', NULL),						-- REJECT. Start date is before current start date.
	(99, 7, '2024-02-27', '2024-03-03'),				-- REJECT. Price is the same as the active row.
	(99, 8, '2024-02-27', NULL),						-- REJECT. Same date has been specified multiple times.
	(99, 9, '2024-02-27', '2024-03-12'),				-- REJECT. Same date has been specified multiple times.
	(99, 5.7915, '2024-02-28', NULL),					-- REJECT. Price is already active.
	(99, 7.5, '2024-02-29', '2024-03-05'),				
	(99, 8, '2024-03-06', '2024-03-17'),
	(99, 9, '2024-10-11', '2023-09-12'),				-- REJECT. End date is earlier than the start date.
	(99, 6.5, '2023-01-01', '2023-12-31'),				-- REJECT. Specified stock item ID does not exist.
	(99, 12, '2024-08-10', NULL),
	(99, 12, '2024-08-12', '2024-08-12'),				-- REJECT. Same price as previous row.
	(99, 0, '2024-12-01', '2024-12-05'),				-- REJECT. Price is zero.
	(99, -5, '2024-12-06', NULL),						-- REJECT. Price is less than zero.
	(150, 2, '2024-01-04', NULL);


UPDATE dbo.StockItemPrice
	SET ItemPrice = 250
WHERE StockItemPriceId = 150;

DELETE dbo.StockItemPrice
	WHERE StockitemPriceId = 99;


SELECT * FROM dbo.StockItemPrice WHERE (StockItemId IN (99, 150))
ORDER BY StockItemId ASC, StartDate ASC;

SELECT * FROM dbo.StockItemPrice WHERE (StockItemPriceId IN (99, 150))
ORDER BY StockItemId ASC, StartDate ASC;

SELECT * FROM dbo.AuditLog;


