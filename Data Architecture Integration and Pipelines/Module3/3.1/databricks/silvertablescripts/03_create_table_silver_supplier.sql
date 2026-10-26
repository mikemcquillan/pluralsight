CREATE TABLE IF NOT EXISTS globodata.silver.supplier
(
  SourceSystem              VARCHAR(100),
  Country                   VARCHAR(20),
  SystemSupplierId          VARCHAR(20),
  SystemSupplierReference   VARCHAR(30),
  CompanyName               VARCHAR(100),
  PrimaryContact            VARCHAR(100),
  AddressLine1              VARCHAR(100),
  AddressLine2              VARCHAR(100),
  Postcode                  VARCHAR(100),
  LastImportDate            TIMESTAMP,
  LastUpdateDate            TIMESTAMP,
  LastUpdatedBy             VARCHAR(100)
);