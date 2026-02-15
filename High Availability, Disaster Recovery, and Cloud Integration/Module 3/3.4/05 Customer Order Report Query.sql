SELECT	C.CustomerName,
		CONVERT(DATE, OH.OrderDate) AS OrderDate,
		COUNT(*) AS NumberOfOrders,
		SUM(OH.TotalCost) AS TotalAmountSpent
FROM dbo.Customer C
	INNER JOIN dbo.OrderHeader OH
		ON C.CustomerId = OH.CustomerId
GROUP BY C.CustomerName,
		 OH.OrderDate
ORDER BY OH.OrderDate DESC,
		 C.CustomerName ASC;