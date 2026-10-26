CREATE TABLE IF NOT EXISTS globodata.silver.product
(
  SourceSystem              VARCHAR(100),
  Country                   VARCHAR(20),
  SystemProductId           VARCHAR(20),
  ProductCategoryCode       VARCHAR(30),
  ProductCategory           VARCHAR(50),
  ProductCode               VARCHAR(50),
  ProductName               VARCHAR(100),
  Price                     DECIMAL(12,2),
  DiscountPercentage        DECIMAL(4,2),
  LastImportDate            TIMESTAMP,
  LastUpdateDate            TIMESTAMP,
  LastUpdatedBy             VARCHAR(100)
);
