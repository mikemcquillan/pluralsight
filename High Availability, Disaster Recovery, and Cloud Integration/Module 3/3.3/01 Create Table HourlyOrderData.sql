CREATE TABLE dbo.HourlyOrderData
(
 ReportDate			DATE	NULL,
 ReportHour			INT		NULL,
 NumberOfOrders		INT		NULL,
 TotalOrderAmount	MONEY	NULL
);

GO

INSERT INTO dbo.HourlyOrderData
	(ReportDate, ReportHour, NumberOfOrders, TotalOrderAmount)
VALUES
	('2025-09-27', 17, 360, 18742.59),
	('2025-10-02', 0, 359, 18378.43),
	('2025-09-29', 8, 98, 3088.58),
	('2025-09-23', 12, 10, 436.29);