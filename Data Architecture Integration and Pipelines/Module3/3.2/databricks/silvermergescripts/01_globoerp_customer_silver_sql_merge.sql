MERGE INTO globodata.silver.customer AS t
USING (
  SELECT
    CASE
      WHEN lower(trim(BC.sourcefilename)) LIKE '%newerp%' THEN 'ERP'
      ELSE lower(regexp_replace(trim(BC.sourcefilename), '(?i)\\.csv$', ''))
    END AS SourceSystem,
    CASE
      WHEN lower(trim(BC.sourcefilename)) LIKE '%newerpnl%' THEN 'NL'
      WHEN lower(trim(BC.sourcefilename)) LIKE '%newerpuk%' THEN 'UK'
      WHEN lower(trim(BC.sourcefilename)) LIKE '%newerpus%' THEN 'US'
    END AS Country,
    BC.customerid AS SystemCustomerId,
    BC.ourref AS SystemCustomerReference,
    BC.title AS Title,
    BC.gender AS Gender,
    BC.addressline1 AS AddressLine1,
    BC.addressline2 AS AddressLine2,
    BC.addressline3 AS City,
    CAST(NULL AS STRING) AS Postcode,
    CAST(BC.importdate AS TIMESTAMP) AS LastImportDate,
    CAST(BC.lastupdated AS TIMESTAMP) AS LastUpdateDate,
    BC.lastupdatedby AS LastUpdatedBy
  FROM globodata.bronze.globoerp_customer BC
    LEFT JOIN globodata.silver.customer SC
      ON SC.SourceSystem = 'ERP'
        AND BC.CustomerId = SC.SystemCustomerId
        AND 
        CASE
          WHEN lower(trim(BC.sourcefilename)) LIKE '%newerpnl%' THEN 'NL'
          WHEN lower(trim(BC.sourcefilename)) LIKE '%newerpuk%' THEN 'UK'
          WHEN lower(trim(BC.sourcefilename)) LIKE '%newerpus%' THEN 'US'
        END = SC.Country
  WHERE SC.SystemCustomerId IS NULL
    OR (SC.SystemCustomerId IS NOT NULL AND BC.ImportDate > SC.LastImportDate)
) AS s
ON  t.SourceSystem = s.SourceSystem
AND t.SystemCustomerId = s.SystemCustomerId
AND t.Country = s.Country

WHEN MATCHED THEN UPDATE SET
  t.SystemCustomerReference = s.SystemCustomerReference,
  t.Title = s.Title,
  t.Gender = s.Gender,
  t.AddressLine1 = s.AddressLine1,
  t.AddressLine2 = s.AddressLine2,
  t.City = s.City,
  t.Postcode = s.Postcode,
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
  AddressLine2,
  City,
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
  s.AddressLine2,
  s.City,
  s.Postcode,
  s.LastImportDate,
  s.LastUpdateDate,
  s.LastUpdatedBy
);