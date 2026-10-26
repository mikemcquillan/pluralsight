CREATE FUNCTION globodata.silver.supplier_filter(systemsupplierreference STRING) RETURNS BOOLEAN
RETURN systemsupplierreference IN ('ADV', ‘ALP’);

ALTER TABLE globodata.silver.supplier 
    SET ROW FILTER globodata.silver.supplier_filter ON (systemsupplierreference);

SELECT * FROM globodata.silver.supplier;

ALTER TABLE globodata.silver.supplier DROP ROW FILTER;