TRUNCATE TABLE globodata.gold.salesordersummary;

INSERT INTO globodata.gold.salesordersummary
  (Country, OrderDate, OrderDateYear, OrderDateMonth, OrderDateDay,
   Customer, OrderStatus,OrderTotal)
SELECT  SO.Country,
        SO.OrderDate,
        YEAR(SO.OrderDate) AS OrderDateYear,
        CONCAT(MONTH(SO.OrderDate), '-', YEAR(SO.OrderDate)) AS OrderDateMonth,
        DAY(SO.OrderDate) AS OrderDateDay,
        C.Name,
        SO.OrderStatus,
        SUM(SOL.LineTotal) AS OrderTotal
FROM globodata.silver.salesorder SO
  INNER JOIN globodata.silver.salesorderline SOL
    ON SO.SourceSystem = SOL.SourceSystem
      AND SO.Country = SOL.Country
      AND SO.SystemSalesOrderId = SOL.SystemSalesOrderId
  INNER JOIN globodata.silver.customer C
    ON SO.SourceSystem = C.SourceSystem
      AND SO.Country = C.Country
      AND SO.SystemCustomerId = C.SystemCustomerId
GROUP BY SO.Country,
         SO.OrderDate,
         C.Name,
         SO.OrderStatus;