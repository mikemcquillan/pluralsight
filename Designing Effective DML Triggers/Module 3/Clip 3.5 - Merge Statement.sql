USE StockSystem;

TRUNCATE TABLE dbo.AuditLog;

MERGE dbo.StockItemPrice AS tgt
	USING (SELECT StockItemPriceId, ItemPrice, StartDate, EndDate
			FROM dbo.StockItemPrice) AS src
				ON tgt.StockItemPriceId = src.StockItemPriceId
	WHEN MATCHED AND src.StockItemPriceId NOT BETWEEN 100 AND 199
		THEN DELETE
	WHEN MATCHED
		THEN UPDATE
			SET ItemPrice = 200,
				StartDate = '2020-03-20',
				EndDate = '2020-12-31';

SELECT * FROM dbo.AuditLog WHERE ChangeNotes = 'deletion attempted';
SELECT * FROM dbo.AuditLog WHERE ChangeNotes != 'deletion attempted';