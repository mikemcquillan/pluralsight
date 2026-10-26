CREATE TABLE IF NOT EXISTS globodata.silver.stocklevel
(
  SourceSystem              VARCHAR(100),
  Country                   VARCHAR(20),
  SystemProductCode         VARCHAR(30),
  SystemWarehouseCode       VARCHAR(20),
  CurrentStockLevel         INTEGER,
  DueStockLevel             INTEGER,
  AllocatedStockLevel       INTEGER,
  PhysicalStockLevel        INTEGER,
  LastImportDate            TIMESTAMP,
  LastUpdateDate            TIMESTAMP,
  LastUpdatedBy             VARCHAR(100)
);
