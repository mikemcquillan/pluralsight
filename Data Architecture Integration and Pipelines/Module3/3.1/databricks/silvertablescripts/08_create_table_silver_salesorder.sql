CREATE TABLE IF NOT EXISTS globodata.silver.salesorder
(
  SourceSystem              VARCHAR(100),
  Country                   VARCHAR(20),
  SystemSalesOrderId        INTEGER,
  SystemCustomerId          VARCHAR(100),
  OrderStatus               VARCHAR(30),
  OurReference              VARCHAR(30),
  CustomerReference         VARCHAR(50),
  OrderDate                 TIMESTAMP,
  ConfirmedDate             TIMESTAMP,
  LastImportDate            TIMESTAMP,
  LastUpdateDate            TIMESTAMP,
  LastUpdatedBy             VARCHAR(100)
);