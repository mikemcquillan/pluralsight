MERGE INTO globodata.silver.supplier AS t
USING (
  SELECT
    CASE
      WHEN lower(trim(sourcefilename)) LIKE '%newerp%' THEN 'ERP'
      ELSE lower(regexp_replace(trim(sourcefilename), '(?i)\\.csv$', ''))
    END AS SourceSystem,
    CASE
      WHEN lower(trim(sourcefilename)) LIKE '%newerpnl%' THEN 'NL'
      WHEN lower(trim(sourcefilename)) LIKE '%newerpuk%' THEN 'UK'
      WHEN lower(trim(sourcefilename)) LIKE '%newerpus%' THEN 'US'
    END AS Country,
    supplierid AS SystemSupplierId,
    ourref AS SystemSupplierReference,
    companyname AS CompanyName,
    primarycontact AS PrimaryContact,
    addressline1 AS AddressLine1,
    addressline2 AS AddressLine2,
    addressline3 AS Postcode,
    CAST(importdate AS TIMESTAMP) AS LastImportDate,
    CAST(lastupdated AS TIMESTAMP) AS LastUpdateDate,
    lastupdatedby AS LastUpdatedBy
  FROM globodata.bronze.globoerp_supplier
) AS s
ON  t.SourceSystem = s.SourceSystem
AND t.SystemSupplierId = s.SystemSupplierId
AND t.Country = s.Country

WHEN MATCHED THEN UPDATE SET
  t.SystemSupplierReference = s.SystemSupplierReference,
  t.PrimaryContact = s.PrimaryContact,
  t.CompanyName = s.CompanyName,
  t.AddressLine1 = s.AddressLine1,
  t.AddressLine2 = s.AddressLine2,
  t.Postcode = s.Postcode,
  t.LastImportDate = s.LastImportDate,
  t.LastUpdateDate = s.LastUpdateDate,
  t.LastUpdatedBy = s.LastUpdatedBy

WHEN NOT MATCHED THEN INSERT (
  SourceSystem,
  Country,
  SystemSupplierId,
  SystemSupplierReference,
  PrimaryContact,
  CompanyName,
  AddressLine1,
  AddressLine2,
  Postcode,
  LastImportDate,
  LastUpdateDate,
  LastUpdatedBy
) VALUES (
  s.SourceSystem,
  s.Country,
  s.SystemSupplierId,
  s.SystemSupplierReference,
  s.PrimaryContact,
  s.CompanyName,
  s.AddressLine1,
  s.AddressLine2,
  s.Postcode,
  s.LastImportDate,
  s.LastUpdateDate,
  s.LastUpdatedBy
);