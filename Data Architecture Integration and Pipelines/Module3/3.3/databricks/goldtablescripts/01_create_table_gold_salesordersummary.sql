CREATE TABLE IF NOT EXISTS globodata.gold.salesordersummary
(
  Country                   VARCHAR(20),
  OrderDate                 TIMESTAMP,
  OrderDateYear             INTEGER,
  OrderDateMonth            VARCHAR(7),
  OrderDateDay              VARCHAR(10),
  Customer                  VARCHAR(100),
  OrderStatus               VARCHAR(30),
  OrderTotal                DECIMAL(12,2)
);