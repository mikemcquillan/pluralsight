CREATE TABLE IF NOT EXISTS globodata.silver.purchaseorder
(
  SourceSystem              VARCHAR(100),
  Country                   VARCHAR(20),
  SystemPurchaseOrderId     INTEGER,
  SystemSupplierId          VARCHAR(20),
  OrderStatus               VARCHAR(30),
  OurReference              VARCHAR(30),
  SupplierReference         VARCHAR(50),
  OrderDate                 TIMESTAMP,
  ConfirmedDate             TIMESTAMP,
  LastImportDate            TIMESTAMP,
  LastUpdateDate            TIMESTAMP,
  LastUpdatedBy             VARCHAR(100)
);