CREATE OR REPLACE FUNCTION globodata.silver.mask_string_except_first_char(value STRING)
RETURNS STRING
RETURN CASE
  WHEN value IS NULL THEN NULL
  WHEN length(value) <= 1 THEN value
  ELSE concat(substring(value, 1, 1), repeat('*', length(value) - 1))
END;

ALTER TABLE globodata.silver.supplier
    ALTER COLUMN companyname
        SET MASK globodata.silver.mask_string_except_first_char;

SELECT * FROM globodata.silver.supplier;

ALTER TABLE globodata.silver.supplier
    ALTER COLUMN companyname
        DROP MASK;
