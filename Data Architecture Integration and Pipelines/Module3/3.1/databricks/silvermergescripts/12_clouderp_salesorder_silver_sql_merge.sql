-- Merge the products
MERGE INTO globodata.silver.product AS t
USING (
  SELECT DISTINCT
    'CloudERP' AS SourceSystem,
    'DE' AS Country,
    RIGHT(SO.ProductCode, 3) AS SystemProductId,
    SO.productcode AS ProductCode,
    SO.productname AS ProductName,
    SO.unitprice AS Price,
    CAST(SO.importdate AS TIMESTAMP) AS LastImportDate,
    CAST(SO.entrydate AS TIMESTAMP) AS LastUpdateDate,
    SO.lastupdatedby AS LastUpdatedBy
  FROM globodata.bronze.clouderp_salesorder SO
    LEFT JOIN globodata.silver.product P
      ON RIGHT(SO.ProductCode, 3) = P.SystemProductId
        AND P.Country = 'DE'
  WHERE P.SystemProductId IS NULL
) AS s
ON  t.SourceSystem = s.SourceSystem
AND t.SystemProductId = s.SystemProductId
AND t.Country = s.Country

WHEN MATCHED THEN UPDATE SET
  t.ProductCode = s.ProductCode,
  t.ProductName = s.ProductName,
  t.Price = s.Price,
  t.LastImportDate = s.LastImportDate,
  t.LastUpdateDate = s.LastUpdateDate,
  t.LastUpdatedBy = s.LastUpdatedBy

WHEN NOT MATCHED THEN INSERT (
  SourceSystem,
  Country,
  SystemProductId,
  ProductCode,
  ProductName,
  Price,
  LastImportDate,
  LastUpdateDate,
  LastUpdatedBy
) VALUES (
  s.SourceSystem,
  s.Country,
  s.SystemProductId,
  s.ProductCode,
  s.ProductName,
  s.Price,
  s.LastImportDate,
  s.LastUpdateDate,
  s.LastUpdatedBy
);

-- Merge the sales orders
MERGE INTO globodata.silver.salesorder AS t
USING (
  SELECT DISTINCT
    'CloudERP' AS SourceSystem,
    'DE' AS Country,
    salesorderid AS SystemSalesOrderId,
    customerref AS SystemCustomerId,
    CASE 
      WHEN confirmeddate IS NULL THEN 'Pending'
      WHEN confirmeddate IS NOT NULL THEN 'Confirmed'
    END AS OrderStatus,
    ourref AS OurReference,
    customerref AS CustomerReference,
    orderdate AS OrderDate,
    confirmeddate AS ConfirmedDate,
    CAST(importdate AS TIMESTAMP) AS LastImportDate,
    CAST(entrydate AS TIMESTAMP) AS LastUpdateDate,
    lastupdatedby AS LastUpdatedBy
  FROM globodata.bronze.clouderp_salesorder
    WHERE Action IN ('Insert', 'Update')
) AS s
ON  t.SourceSystem = s.SourceSystem
AND t.SystemSalesOrderId = s.SystemSalesOrderId
AND t.Country = s.Country

WHEN MATCHED THEN UPDATE SET
  t.SystemCustomerId = s.SystemCustomerId,
  t.OrderStatus = s.OrderStatus,
  t.OurReference = s.OurReference,
  t.CustomerReference = s.CustomerReference,
  t.OrderDate = s.OrderDate,
  t.ConfirmedDate = s.ConfirmedDate,
  t.LastImportDate = s.LastImportDate,
  t.LastUpdateDate = s.LastUpdateDate,
  t.LastUpdatedBy = s.LastUpdatedBy

WHEN NOT MATCHED THEN INSERT (
  SourceSystem,
  Country,
  SystemSalesOrderId,
  SystemCustomerId,
  OrderStatus,
  OurReference,
  CustomerReference,
  OrderDate,
  ConfirmedDate,
  LastImportDate,
  LastUpdateDate,
  LastUpdatedBy
) VALUES (
  s.SourceSystem,
  s.Country,
  s.SystemSalesOrderId,
  s.SystemCustomerId,
  s.OrderStatus,
  s.OurReference,
  s.CustomerReference,
  s.OrderDate,
  s.ConfirmedDate,
  s.LastImportDate,
  s.LastUpdateDate,
  s.LastUpdatedBy
);

-- Process same events, for the sales order lines
MERGE INTO globodata.silver.salesorderline AS t
USING (
  SELECT
    'CloudERP' AS SourceSystem,
    'DE' AS Country,
    salesorderid AS SystemSalesOrderId,
    'DE' AS SystemWarehouseCode,
    RIGHT(ProductCode, 3) AS SystemProductId,
    linenumber AS Ordinal,
    quantity AS Quantity,
    unitprice AS ItemPrice,
    unitprice * quantity AS LineTotal,
    CAST(importdate AS TIMESTAMP) AS LastImportDate,
    CAST(entrydate AS TIMESTAMP) AS LastUpdateDate,
    lastupdatedby AS LastUpdatedBy
  FROM globodata.bronze.clouderp_salesorder
) AS s
ON  t.SourceSystem = s.SourceSystem
AND t.SystemSalesOrderId = s.SystemSalesOrderId
AND t.Ordinal = s.Ordinal
AND t.Country = s.Country

WHEN MATCHED THEN UPDATE SET
  t.SystemWarehouseCode = s.SystemWarehouseCode,
  t.SystemProductId = s.SystemProductId,
  t.Quantity = s.Quantity,
  t.ItemPrice = s.ItemPrice,
  t.LineTotal = s.LineTotal,
  t.LastImportDate = s.LastImportDate,
  t.LastUpdateDate = s.LastUpdateDate,
  t.LastUpdatedBy = s.LastUpdatedBy

WHEN NOT MATCHED THEN INSERT (
  SourceSystem,
  Country,
  SystemSalesOrderId,
  SystemWarehouseCode,
  SystemProductId,
  Ordinal,
  Quantity,
  ItemPrice,
  LineTotal,
  LastImportDate,
  LastUpdateDate,
  LastUpdatedBy
) VALUES (
  s.SourceSystem,
  s.Country,
  s.SystemSalesOrderId,
  s.SystemWarehouseCode,
  s.SystemProductId,
  s.Ordinal,
  s.Quantity,
  s.ItemPrice,
  s.LineTotal,
  s.LastImportDate,
  s.LastUpdateDate,
  s.LastUpdatedBy
);