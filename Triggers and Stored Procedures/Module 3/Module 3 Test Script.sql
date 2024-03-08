USE StockSystem;

INSERT INTO dbo.OrderHeader 
	(CustomerId, OrderReference)
VALUES 
	(16, 'AP_TEST'),
	(2, 'DP_TEST'),
	(15, 'GF_TEST'),
	(3, 'RA_TEST'),
	(4, 'BM_TEST');

SELECT	CustomerName
	FROM dbo.Customer
GROUP BY CustomerName HAVING COUNT(*) > 1;

SELECT *
	FROM dbo.Customer
WHERE CustomerName IN 
(
 'Alan Partridge',
 'Dennis Potter',
 'George Formby',
 'Richard Adams'
)
ORDER BY CustomerName ASC;

SELECT	C.CustomerName,
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

SELECT * FROM dbo.AuditLog;
