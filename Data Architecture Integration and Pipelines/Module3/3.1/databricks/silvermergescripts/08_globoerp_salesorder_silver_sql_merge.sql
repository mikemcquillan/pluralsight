MERGE INTO globodata.silver.salesorder AS t
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
    customerid AS SystemCustomerId,
    orderstatus AS OrderStatus,
    ourref AS OurReference,
    customerref AS CustomerReference,
    orderdate AS OrderDate,
    confirmeddate AS ConfirmedDate,
    CAST(importdate AS TIMESTAMP) AS LastImportDate,
    CAST(lastupdated AS TIMESTAMP) AS LastUpdateDate,
    lastupdatedby AS LastUpdatedBy
  FROM globodata.bronze.globoerp_salesorder
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