MERGE INTO globodata.silver.stocklevel AS t
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
    productcode AS SystemProductCode,
    warehousecode AS SystemWarehouseCode,
    currentstocklevel AS CurrentStockLevel,
    duestocklevel AS DueStockLevel,
    allocatedstocklevel AS AllocatedStockLevel,
    physicalstocklevel AS PhysicalStockLevel,
    CAST(importdate AS TIMESTAMP) AS LastImportDate,
    CAST(lastupdated AS TIMESTAMP) AS LastUpdateDate,
    lastupdatedby AS LastUpdatedBy
  FROM globodata.bronze.globoerp_stocklevel
) AS s
ON  t.SourceSystem = s.SourceSystem
AND t.SystemProductCode = s.SystemProductCode
AND t.SystemWarehouseCode = s.SystemWarehouseCode
AND t.Country = s.Country

WHEN MATCHED THEN UPDATE SET
  t.CurrentStockLevel = s.CurrentStockLevel,
  t.DueStockLevel = s.DueStockLevel,
  t.AllocatedStockLevel = s.AllocatedStockLevel,
  t.PhysicalStockLevel = s.PhysicalStockLevel,
  t.LastImportDate = s.LastImportDate,
  t.LastUpdateDate = s.LastUpdateDate,
  t.LastUpdatedBy = s.LastUpdatedBy

WHEN NOT MATCHED THEN INSERT (
  SourceSystem,
  Country,
  SystemProductCode,
  SystemWarehouseCode,
  CurrentStockLevel,
  DueStockLevel,
  AllocatedStockLevel,
  PhysicalStockLevel,
  LastImportDate,
  LastUpdateDate,
  LastUpdatedBy
) VALUES (
  s.SourceSystem,
  s.Country,
  s.SystemProductCode,
  s.SystemWarehouseCode,
  s.CurrentStockLevel,
  s.DueStockLevel,
  s.AllocatedStockLevel,
  s.PhysicalStockLevel,
  s.LastImportDate,
  s.LastUpdateDate,
  s.LastUpdatedBy
);