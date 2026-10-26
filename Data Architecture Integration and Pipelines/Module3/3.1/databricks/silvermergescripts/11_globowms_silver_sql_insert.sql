INSERT INTO globodata.silver.wmsevent
(
  SourceSystem,
  Country,
  ScannerId,
  Action,
  OrderNumber,
  OrderType,
  Warehouse,
  ProductCode,
  Quantity,
  ActionDate,
  LastImportDate
)
SELECT
  'GloboWMS' AS SourceSystem,
  country AS Country,
  scannerid AS ScannerId,
  action AS Action,
  ordernumber AS OrderNumber,
  ordertype AS OrderType,
  warehouse AS Warehouse,
  productcode AS ProductCode,
  quantity AS Quantity,
  CAST(entrydate AS TIMESTAMP) AS ActionDate,
  CAST(importdate AS TIMESTAMP) AS LastImportDate
FROM globodata.bronze.globowms_event
WHERE IsSilver = False;

UPDATE globodata.bronze.globowms_event
  SET IsSilver = True
WHERE IsSilver = False;
