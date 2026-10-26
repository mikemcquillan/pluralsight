MERGE INTO globodata.silver.salesorderline AS t
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
    salesorderid AS SystemSalesOrderId,
    warehousecode AS SystemWarehouseCode,
    productId AS SystemProductId,
    ordinal AS Ordinal,
    quantity AS Quantity,
    REPLACE(REPLACE(itemprice, '£', ''), ',', '') AS ItemPrice,
    REPLACE(REPLACE(linetotal, '£', ''), ',', '') AS LineTotal,
    CAST(importdate AS TIMESTAMP) AS LastImportDate,
    CAST(lastupdated AS TIMESTAMP) AS LastUpdateDate,
    lastupdatedby AS LastUpdatedBy
  FROM globodata.bronze.globoerp_salesorderline
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