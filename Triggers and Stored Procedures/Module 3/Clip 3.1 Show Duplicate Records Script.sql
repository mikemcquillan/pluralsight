USE StockSystem;

SELECT	CustomerName
	FROM dbo.Customer
GROUP BY CustomerName HAVING COUNT(*) > 1;

SELECT	C.CustomerName,
		C.IsActive,
		OH.*
	FROM dbo.OrderHeader OH
		INNER JOIN dbo.Customer C
			ON OH.CustomerId = C.CustomerId
WHERE C.CustomerName
IN
(
 SELECT	CustomerName
	FROM dbo.Customer
 GROUP BY CustomerName HAVING COUNT(*) > 1
)
ORDER BY C.CustomerName ASC;
