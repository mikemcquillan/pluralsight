USE StockSystem;

GO

INSERT INTO StockItemPrice
(
 StockItemId,
 ItemPrice,
 StartDate,
 EndDate
)
SELECT
StockItemId,
COALESCE(BasePrice, 4.99),
'2021-03-22',
'2021-10-24'
FROM dbo.StockItem;

INSERT INTO StockItemPrice
(
 StockItemId,
 ItemPrice,
 StartDate,
 EndDate
)
SELECT
StockItemId,
CONVERT(MONEY, (ItemPrice * 1.1)),
'2021-10-25',
'2022-08-19'
FROM StockItemPrice
WHERE StartDate = '2021-03-22';

INSERT INTO StockItemPrice
(
 StockItemId,
 ItemPrice,
 StartDate,
 EndDate
)
SELECT
StockItemId,
CONVERT(MONEY, (ItemPrice * 1.3)),
'2022-08-20',
'2023-06-01'
FROM StockItemPrice
WHERE StartDate = '2021-10-25';

INSERT INTO StockItemPrice
(
 StockItemId,
 ItemPrice,
 StartDate,
 EndDate
)
SELECT
StockItemId,
CONVERT(MONEY, (ItemPrice * 1.5)),
'2023-06-02',
NULL
FROM StockItemPrice
WHERE StartDate = '2022-08-20';

GO


