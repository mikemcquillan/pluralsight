MERGE INTO globodata.silver.customer AS t
USING (
  SELECT DISTINCT
    'CloudERP' AS SourceSystem,
    'DE' AS Country,
    id AS SystemCustomerId,
    ourref AS SystemCustomerReference,
    title AS Title,
    gender AS Gender,
    address AS AddressLine1,
    CAST(NULL AS STRING) AS Postcode,
    CAST(importdate AS TIMESTAMP) AS LastImportDate,
    CAST(entrydate AS TIMESTAMP) AS LastUpdateDate,
    user AS LastUpdatedBy
  FROM globodata.bronze.clouderp_contact
    WHERE call = 'GetCustomer'
) AS s
ON  t.SourceSystem = s.SourceSystem
AND t.SystemCustomerId = s.SystemCustomerId
AND t.Country = s.Country

WHEN MATCHED THEN UPDATE SET
  t.SystemCustomerReference = s.SystemCustomerReference,
  t.Title = s.Title,
  t.Gender = s.Gender,
  t.AddressLine1 = s.AddressLine1,
  t.LastImportDate = s.LastImportDate,
  t.LastUpdateDate = s.LastUpdateDate,
  t.LastUpdatedBy = s.LastUpdatedBy

WHEN NOT MATCHED THEN INSERT (
  SourceSystem,
  Country,
  SystemCustomerId,
  SystemCustomerReference,
  Title,
  Gender,
  AddressLine1,
  Postcode,
  LastImportDate,
  LastUpdateDate,
  LastUpdatedBy
) VALUES (
  s.SourceSystem,
  s.Country,
  s.SystemCustomerId,
  s.SystemCustomerReference,
  s.Title,
  s.Gender,
  s.AddressLine1,
  s.Postcode,
  s.LastImportDate,
  s.LastUpdateDate,
  s.LastUpdatedBy
);

MERGE INTO globodata.silver.supplier AS t
USING (
  SELECT DISTINCT
    'CloudERP' AS SourceSystem,
    'DE' AS Country,
    id AS SystemSupplierId,
    ourref AS SystemSupplierReference,
    companyname AS CompanyName,
    name AS PrimaryContact,
    address AS AddressLine1,
    CAST(NULL AS STRING) AS Postcode,
    CAST(importdate AS TIMESTAMP) AS LastImportDate,
    CAST(entrydate AS TIMESTAMP) AS LastUpdateDate,
    user AS LastUpdatedBy
  FROM globodata.bronze.clouderp_contact
    WHERE call = 'GetSupplier'
) AS s
ON  t.SourceSystem = s.SourceSystem
AND t.SystemSupplierId = s.SystemSupplierId
AND t.Country = s.Country

WHEN MATCHED THEN UPDATE SET
  t.SystemSupplierReference = s.SystemSupplierReference,
  t.CompanyName = s.CompanyName,
  t.PrimaryContact = s.PrimaryContact,
  t.AddressLine1 = s.AddressLine1,
  t.LastImportDate = s.LastImportDate,
  t.LastUpdateDate = s.LastUpdateDate,
  t.LastUpdatedBy = s.LastUpdatedBy

WHEN NOT MATCHED THEN INSERT (
  SourceSystem,
  Country,
  SystemSupplierId,
  SystemSupplierReference,
  CompanyName,
  PrimaryContact,
  AddressLine1,
  Postcode,
  LastImportDate,
  LastUpdateDate,
  LastUpdatedBy
) VALUES (
  s.SourceSystem,
  s.Country,
  s.SystemSupplierId,
  s.SystemSupplierReference,
  s.CompanyName,
  s.PrimaryContact,
  s.AddressLine1,
  s.Postcode,
  s.LastImportDate,
  s.LastUpdateDate,
  s.LastUpdatedBy
);