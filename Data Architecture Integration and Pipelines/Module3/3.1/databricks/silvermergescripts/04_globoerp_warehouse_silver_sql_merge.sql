MERGE INTO globodata.silver.warehouse AS t
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
    warehousecode AS SystemWarehouseCode,
    warehousename AS WarehouseName,
    addressline1 AS AddressLine1,
    addressline2 AS AddressLine2,
    addressline3 AS Postcode,
    CAST(importdate AS TIMESTAMP) AS LastImportDate,
    CAST(lastupdated AS TIMESTAMP) AS LastUpdateDate,
    lastupdatedby AS LastUpdatedBy
  FROM globodata.bronze.globoerp_warehouse
) AS s
ON  t.SourceSystem = s.SourceSystem
AND t.SystemWarehouseCode = s.SystemWarehouseCode
AND t.Country = s.Country

WHEN MATCHED THEN UPDATE SET
  t.warehousename = s.WarehouseName,
  t.AddressLine1 = s.AddressLine1,
  t.AddressLine2 = s.AddressLine2,
  t.Postcode = s.Postcode,
  t.LastImportDate = s.LastImportDate,
  t.LastUpdateDate = s.LastUpdateDate,
  t.LastUpdatedBy = s.LastUpdatedBy

WHEN NOT MATCHED THEN INSERT (
  SourceSystem,
  Country,
  SystemWarehouseCode,
  WarehouseName,
  AddressLine1,
  AddressLine2,
  Postcode,
  LastImportDate,
  LastUpdateDate,
  LastUpdatedBy
) VALUES (
  s.SourceSystem,
  s.Country,
  s.SystemWarehouseCode,
  s.WarehouseName,
  s.AddressLine1,
  s.AddressLine2,
  s.Postcode,
  s.LastImportDate,
  s.LastUpdateDate,
  s.LastUpdatedBy
);