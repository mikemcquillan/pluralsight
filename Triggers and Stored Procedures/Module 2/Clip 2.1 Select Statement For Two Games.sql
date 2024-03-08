USE StockSystem;

SELECT	SIP.StockItemPriceId,
		SI.StockItemId,
		SI.Title,
		SIP.ItemPrice,
		SIP.StartDate,
		SIP.EndDate
	FROM dbo.StockItem SI
		INNER JOIN dbo.StockItemPrice SIP
			ON SI.StockItemId = SIP.StockItemId
WHERE SI.StockItemId IN (99, 150)
ORDER BY SI.StockItemId ASC, SIP.StartDate ASC;