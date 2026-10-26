CREATE TABLE IF NOT EXISTS globodata.silver.purchaseorderline
(
  SourceSystem              VARCHAR(100),
  Country                   VARCHAR(20),
  SystemPurchaseOrderId     INTEGER,
  Ordinal                   INTEGER,
  SystemWarehouseCode       VARCHAR(20),
  SystemProductId           INTEGER,
  Quantity                  INTEGER,
  ItemPrice                 DECIMAL(12,2),
  LineTotal                 DECIMAL(12,2),
  LastImportDate            TIMESTAMP,
  LastUpdateDate            TIMESTAMP,
  LastUpdatedBy             VARCHAR(100)
);