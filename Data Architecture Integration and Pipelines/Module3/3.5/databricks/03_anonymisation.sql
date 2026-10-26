CREATE TABLE globodata.silver.fakename
(
  FakeName    VARCHAR(50)
);

INSERT INTO globodata.silver.fakename (fakename)
WITH names AS
(
  SELECT CONCAT('Fake Name ', ROW_NUMBER() OVER (ORDER BY SystemCustomerId ASC)) AS fakename
  FROM globodata.silver.customer
)
SELECT fakename FROM names;

WITH customers 
AS 
(
 SELECT SystemCustomerId, 
        Country, 
        ROW_NUMBER() OVER (ORDER BY SystemCustomerId) AS rownum
  FROM globodata.silver.customer
), 
newnames 
AS 
(
  SELECT fakename, 
        ROW_NUMBER() OVER (ORDER BY fakename) AS rownum  
   FROM globodata.silver.fakename
)
SELECT C.SystemCustomerId, C.Name, NN.fakename, C.country
   FROM globodata.silver.customer C 
    INNER JOIN customers TC
      ON C.SystemCustomerId = TC.SystemCustomerId
        AND C.Country = TC.Country
    INNER JOIN newnames NN 
      ON TC.rownum = NN.rownum
ORDER BY C.Country;
