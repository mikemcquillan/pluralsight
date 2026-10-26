MERGE INTO globodata.silver.purchaseorder AS t
USING (
  SELECT
    CASE
      WHEN lower(trim(sourcefilename)) LIKE '%newerp%' THEN 'ERP'
      ELSE lower(regexp_replace(trim(sourcefilename), '(?i)\\.csv$', ''))
    END AS SourceSystem,
    CASE
      WHEN lower(trim(sourcefilename)) LIKE '%newerpnl%' THEN 'NL'
      WHEN lower(trim(sourcefilename)) LIKE '%newerpuk%' THEN 'UK'
      WHEN lower(trim(sourcefilename)) LIKE '%newerpus%' THEN 'US'
    END AS Country,
    purchaseorderid AS SystemPurchaseOrderId,
    supplierid AS SystemSupplierId,
    orderstatus AS OrderStatus,
    ourref AS OurReference,
    supplierref AS SupplierReference,
    orderdate AS OrderDate,
    confirmeddate AS ConfirmedDate,
    CAST(importdate AS TIMESTAMP) AS LastImportDate,
    CAST(lastupdated AS TIMESTAMP) AS LastUpdateDate,
    lastupdatedby AS LastUpdatedBy
  FROM globodata.bronze.globoerp_purchaseorder
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