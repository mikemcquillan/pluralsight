CREATE TABLE IF NOT EXISTS globodata.silver.customer
(
  SourceSystem              VARCHAR(100),
  Country                   VARCHAR(20),
  SystemCustomerId          VARCHAR(20),
  SystemCustomerReference   VARCHAR(30),
  Title                     VARCHAR(30),
  Name			    VARCHAR(100),
  Gender                    VARCHAR(30),
  AddressLine1              VARCHAR(100),
  AddressLine2              VARCHAR(100),
  City                      VARCHAR(100),
  Postcode                  VARCHAR(100),
  LastImportDate            TIMESTAMP,
  LastUpdateDate            TIMESTAMP,
  LastUpdatedBy             VARCHAR(100)
);
