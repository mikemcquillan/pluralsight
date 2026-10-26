CREATE TABLE IF NOT EXISTS globodata.silver.customertoken 
(  
 SystemCustomerId   STRING,
 Token              STRING
);

MERGE INTO globodata.silver.customertoken AS T
USING 
(
 SELECT DISTINCT CAST(SystemCustomerId AS STRING) AS SystemCustomerId  
  FROM globodata.silver.customer
  WHERE SystemCustomerId IS NOT NULL
) AS S 
ON T.SystemCustomerId = S.SystemCustomerId 
WHEN NOT MATCHED THEN  
INSERT (SystemCustomerId, Token) VALUES (S.SystemCustomerId, UUID());

SELECT C.SystemCustomerId, 
       C.Name, 
       CT.Token
FROM globodata.silver.customer C 
  INNER JOIN globodata.silver.customertoken CT
    ON C.SystemCustomerId = CT.SystemCustomerId;
