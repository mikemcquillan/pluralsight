-- Merge the products
MERGE INTO globodata.silver.product AS t
USING (
  SELECT DISTINCT
    'CloudERP' AS SourceSystem,
    'DE' AS Country,
    RIGHT(PO.ProductCode, 3) AS SystemProductId,
    PO.productcode AS ProductCode,
    PO.productname AS ProductName,
    PO.unitprice AS Price,
    CAST(PO.importdate AS TIMESTAMP) AS LastImportDate,
    CAST(PO.entrydate AS TIMESTAMP) AS LastUpdateDate,
    PO.lastupdatedby AS LastUpdatedBy
  FROM globodata.bronze.clouderp_purchaseorder PO
    LEFT JOIN globodata.silver.product P
      ON RIGHT(PO.ProductCode, 3) = P.SystemProductId
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

-- Merge the purchase orders
MERGE INTO globodata.silver.purchaseorder AS t
USING (
  SELECT DISTINCT
    'CloudERP' AS SourceSystem,
    'DE' AS Country,
    purchaseorderid AS SystemPurchaseOrderId,
    supplierref AS SystemSupplierId,
    CASE 
      WHEN confirmeddate IS NULL THEN 'Pending'
      WHEN confirmeddate IS NOT NULL THEN 'Confirmed'
    END AS OrderStatus,
    ourref AS OurReference,
    supplierref AS SupplierReference,
    orderdate AS OrderDate,
    confirmeddate AS ConfirmedDate,
    CAST(importdate AS TIMESTAMP) AS LastImportDate,
    CAST(entrydate AS TIMESTAMP) AS LastUpdateDate,
    lastupdatedby AS LastUpdatedBy
  FROM globodata.bronze.clouderp_purchaseorder
    WHERE Action IN ('Insert', 'Update')
) AS s
ON  t.SourceSystem = s.SourceSystem
AND t.SystemPurchaseOrderId = s.SystemPurchaseOrderId
AND t.Country = s.Country

WHEN MATCHED THEN UPDATE SET
  t.SystemSupplierId = s.SystemSupplierId,
  t.OrderStatus = s.OrderStatus,
  t.OurReference = s.OurReference,
  t.SupplierReference = s.SupplierReference,
  t.OrderDate = s.OrderDate,
  t.ConfirmedDate = s.ConfirmedDate,
  t.LastImportDate = s.LastImportDate,
  t.LastUpdateDate = s.LastUpdateDate,
  t.LastUpdatedBy = s.LastUpdatedBy

WHEN NOT MATCHED THEN INSERT (
  SourceSystem,
  Country,
  SystemPurchaseOrderId,
  SystemSupplierId,
  OrderStatus,
  OurReference,
  SupplierReference,
  OrderDate,
  ConfirmedDate,
  LastImportDate,
  LastUpdateDate,
  LastUpdatedBy
) VALUES (
  s.SourceSystem,
  s.Country,
  s.SystemPurchaseOrderId,
  s.SystemSupplierId,
  s.OrderStatus,
  s.OurReference,
  s.SupplierReference,
  s.OrderDate,
  s.ConfirmedDate,
  s.LastImportDate,
  s.LastUpdateDate,
  s.LastUpdatedBy
);

-- Process same events, for the purchase order lines
MERGE INTO globodata.silver.purchaseorderline AS t
USING (
  SELECT
    'CloudERP' AS SourceSystem,
    'DE' AS Country,
    purchaseorderid AS SystemPurchaseOrderId,
    'DE' AS SystemWarehouseCode,
    RIGHT(ProductCode, 3) AS SystemProductId,
    linenumber AS Ordinal,
    quantity AS Quantity,
    unitprice AS ItemPrice,
    unitprice * quantity AS LineTotal,
    CAST(importdate AS TIMESTAMP) AS LastImportDate,
    CAST(entrydate AS TIMESTAMP) AS LastUpdateDate,
    lastupdatedby AS LastUpdatedBy
  FROM globodata.bronze.clouderp_purchaseorder
) AS s
ON  t.SourceSystem = s.SourceSystem
AND t.SystemPurchaseOrderId = s.SystemPurchaseOrderId
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
  SystemPurchaseOrderId,
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
  s.SystemPurchaseOrderId,
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