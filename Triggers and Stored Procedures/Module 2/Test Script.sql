SELECT * FROM StockItemPrice WHERE StockItemId = 99
ORDER BY StartDate ASC;


INSERT INTO dbo.StockItemPrice
	(StockItemId, ItemPrice, StartDate, EndDate)
VALUES
	(99, 100, '2023-05-04', '2024-05-31'),				-- REJECT. Start date is before current start date.
	(99, 100, '2023-07-10', NULL),						-- REJECT. Start date is before current start date.
	(99, 7, '2024-02-27', '2024-03-03'),				-- REJECT. Price is the same as the active row.
	(99, 8, '2024-02-27', NULL),						-- REJECT. Same date has been specified multiple times.
	(99, 9, '2024-02-27', '2024-03-12'),				-- REJECT. Same date has been specified multiple times.
	(99, 7, '2024-02-28', NULL),						-- REJECT. Price is already active.
	(99, 7.5, '2024-02-29', '2024-03-05'),				
	(99, 8, '2024-03-06', '2024-03-17'),
	(99, 9, '2024-10-11', '2023-09-12'),				-- REJECT. End date is earlier than the start date.
	--(99, 8, '2024-07-01', '2024-07-01'),
	(0, 6.5, '2023-01-01', '2023-12-31'),				-- REJECT. Specified stock item ID does not exist.
	(99, 12, '2024-08-10', NULL),
	(99, 12, '2024-08-12', '2024-08-12'),
	(99, 0, '2024-12-01', '2024-12-05'),
	(99, -5, '2024-12-06', NULL);


--INSERT INTO dbo.StockItemPrice
--	(StockItemId, ItemPrice, StartDate, EndDate)
--VALUES
--	(99, 6, '2023-09-10', '2024-02-15'),
--	(99, 7, '2024-02-16', '2024-04-18'),
--	(99, 8, '2024-04-19', NULL);

--UPDATE dbo.StockItemPrice
--	SET EndDate = '2023-09-09'
--WHERE StockItemPriceId = 6615;

--INSERT INTO dbo.StockItemPrice
--	(StockItemId, ItemPrice, StartDate, EndDate)
--VALUES
--	(99, 6.50, '2024-03-10', '2024-03-15'),
--	(99, 7, '2024-03-16', '2024-04-02');

--UPDATE dbo.StockItemPrice
--	SET EndDate = '2024-03-09'
--WHERE StockItemPriceId = 8690;

--UPDATE dbo.StockItemPrice
--	SET StartDate = '2024-04-03',
--		EndDate = NULL
--WHERE StockItemPriceId = 8691;

---- Active start date = 2023-07-10
---- Active end date = NULL
---- Current date = 2023-06-14

--INSERT INTO dbo.StockItemPrice
--	(StockItemId, ItemPrice, StartDate, EndDate)
--VALUES
--	(99, 100, '2023-06-20', '2023-06-23'),				-- ACCEPT. Start date is after current start date.
														--		   Current active row - 2023-06-02 to 2023-07-09.
														--		   IF there are dates AFTER the row to insert
														--			IF new row end date is after the start date of the existing row
														--				DELETE the existing row
														--			ELSE
														--				UPDATE end date on existing row
														--		   Change end date on current active row to 2023-06-19
														--		   Insert new row

														--		   Change start date on next row to 20