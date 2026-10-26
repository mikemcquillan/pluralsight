CREATE TABLE IF NOT EXISTS globodata.silver.warehouse
(
  SourceSystem              VARCHAR(100),
  Country                   VARCHAR(20),
  SystemWarehouseCode       VARCHAR(20),
  WarehouseName             VARCHAR(100),
  AddressLine1              VARCHAR(100),
  AddressLine2              VARCHAR(100),
  Postcode                  VARCHAR(100),
  LastImportDate            TIMESTAMP,
  LastUpdateDate            TIMESTAMP,
  LastUpdatedBy             VARCHAR(100)
);
