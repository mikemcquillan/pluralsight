MERGE INTO globodata.silver.product AS t
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
    productid AS SystemProductId,
    productcategorycode AS ProductCategoryCode,
    productcategory AS ProductCategory,
    productcode AS ProductCode,
    productname AS ProductName,
    price AS Price,
    discountpercentage AS DiscountPercentage,
    CAST(importdate AS TIMESTAMP) AS LastImportDate,
    CAST(lastupdated AS TIMESTAMP) AS LastUpdateDate,
    lastupdatedby AS LastUpdatedBy
  FROM globodata.bronze.globoerp_product
) AS s
ON  t.SourceSystem = s.SourceSystem
AND t.SystemProductId = s.SystemProductId
AND t.Country = s.Country

WHEN MATCHED THEN UPDATE SET
  t.ProductCategoryCode = s.ProductCategoryCode,
  t.ProductCategory = s.ProductCategory,
  t.ProductCode = s.ProductCode,
  t.ProductName = s.ProductName,
  t.Price = s.Price,
  t.DiscountPercentage = s.DiscountPercentage,
  t.LastImportDate = s.LastImportDate,
  t.LastUpdateDate = s.LastUpdateDate,
  t.LastUpdatedBy = s.LastUpdatedBy

WHEN NOT MATCHED THEN INSERT (
  SourceSystem,
  Country,
  SystemProductId,
  ProductCategoryCode,
  ProductCategory,
  ProductCode,
  ProductName,
  Price,
  DiscountPercentage,
  LastImportDate,
  LastUpdateDate,
  LastUpdatedBy
) VALUES (
  s.SourceSystem,
  s.Country,
  s.SystemProductId,
  s.ProductCategoryCode,
  s.ProductCategory,
  s.ProductCode,
  s.ProductName,
  s.Price,
  s.DiscountPercentage,
  s.LastImportDate,
  s.LastUpdateDate,
  s.LastUpdatedBy
);