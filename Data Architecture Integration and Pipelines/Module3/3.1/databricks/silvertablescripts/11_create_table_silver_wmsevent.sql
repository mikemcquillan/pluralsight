CREATE TABLE IF NOT EXISTS globodata.silver.wmsevent
(
  SourceSystem              VARCHAR(100),
  Country                   VARCHAR(20),
  ScannerId                 VARCHAR(30),
  Action                    VARCHAR(30),
  OrderNumber               INTEGER,
  OrderType                 VARCHAR(30),
  Warehouse                 VARCHAR(30),
  ProductCode               VARCHAR(30),
  Quantity                  INTEGER,
  ActionDate                TIMESTAMP,
  LastImportDate            TIMESTAMP
);