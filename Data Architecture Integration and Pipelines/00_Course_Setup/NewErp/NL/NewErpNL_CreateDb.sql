-- To execute this script:
-- 1. Open a command prompt/terminal/shell.
-- 2. Type this command:

-- psql -U postgres -f "C:\sqlfiles\NewErpNl_CreateDb.sql"

-- Change postgres to your user name, and the file path to wherever you have saved the file.
-- Press Enter to execute the command.
-- Enter your PostgreSQL account password.
-- The script will execute.

DROP DATABASE IF EXISTS NewErpNl;

SELECT 'CREATE DATABASE NewErpNl'
WHERE NOT EXISTS (
    SELECT FROM pg_database
    WHERE datname = 'newerpnl'
)\gexec

\connect newerpnl

CREATE SCHEMA erp;

CREATE TABLE erp.Customer
(
    CustomerId      INT             GENERATED ALWAYS AS IDENTITY,
    OurRef          VARCHAR(10),
    CompanyName     VARCHAR(50),
    CustomerName    VARCHAR(100),
    TitleId         INT,
    GenderId        INT,
    AddressLine1    VARCHAR(100),
    AddresLine2     VARCHAR(100),
    AddressLine3    VARCHAR(100),
    LastUpdatedBy   VARCHAR(100),
    LastUpdated     TIMESTAMP		DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT pk_Customer PRIMARY KEY (CustomerId)
);

CREATE TABLE erp.Gender
(
 GenderId			INT 		GENERATED ALWAYS AS IDENTITY,
 Gender				VARCHAR(20),
 LastUpdatedBy   	VARCHAR(100),
 LastUpdated     	TIMESTAMP		DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT pk_Gender PRIMARY KEY (GenderId)
);

INSERT INTO erp.Gender (Gender, LastUpdatedBy)
VALUES
('Mannelijk', 'Bertie'),
('Vrouwelijk', 'Bertie'),
('Niet gespecificeerd', 'Bertie');

CREATE TABLE erp.Title
(
 TitleId			INT				GENERATED ALWAYS AS IDENTITY,
 Title				VARCHAR(20),
 LastUpdatedBy   	VARCHAR(100),
 LastUpdated     	TIMESTAMP		DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT pk_Title PRIMARY KEY (TitleId)
);

INSERT INTO erp.Title (Title, LastUpdatedBy)
VALUES
('Coach', 'Jo'),
('Meneer', 'Jo'),
('Mevrouw', 'Jo'),
('Juffrouw', 'Jo'),
('Ms', 'Jo'),
('Hertogin', 'Jo'),
('Dr', 'Jo');

CREATE TABLE erp.Supplier
(
    SupplierId      INT             GENERATED ALWAYS AS IDENTITY,
    OurRef          VARCHAR(10),
    CompanyName     VARCHAR(50),
    PrimaryContact  VARCHAR(100),
    AddressLine1    VARCHAR(100),
    AddressLine2    VARCHAR(100),
    AddressLine3    VARCHAR(100),
    LastUpdatedBy   VARCHAR(100),
    LastUpdated     TIMESTAMP		DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT pk_Supplier PRIMARY KEY (SupplierId)
);

CREATE TABLE erp.ProductCategory
(
    ProductCategoryId   INT             GENERATED ALWAYS AS IDENTITY,
    ProductCategoryCode VARCHAR(20),
    ProductCategory     VARCHAR(50),
    LastUpdatedBy       VARCHAR(100),
    LastUpdated         TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT pk_ProductCategory PRIMARY KEY (ProductCategoryId)
);

INSERT INTO erp.ProductCategory 
(ProductCategoryCode, ProductCategory, LastUpdatedBy)
VALUES
('Car', 'Autos & Voertuigen', 'Bob'),
('Caravan', 'Karavaan', 'Terry'),
('Golf', 'Golfkar', 'Bertie'),
('Fork', 'Vorkheftruck', 'Dolly'),
('Truck', 'Vrachtwagen', 'Grace'),
('Lorry', 'Vrachtwagens', 'Jo');

CREATE TABLE erp.Product
(   
    ProductId           INT             GENERATED ALWAYS AS IDENTITY,
    ProductCategoryId   INT,
    ProductCode         VARCHAR(20),
    ProductName         VARCHAR(100),
    Price               MONEY,
    DiscountPercentage  DECIMAL(4,2),
    LastUpdatedBy   	VARCHAR(100),
    LastUpdated     	TIMESTAMP		DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT pk_Product PRIMARY KEY (ProductId)
);

CREATE TABLE erp.Warehouse
(
    WarehouseId     INT					GENERATED ALWAYS AS IDENTITY,
    WarehouseCode   VARCHAR(5),
    WarehouseName   VARCHAR(100),
    AddressLine1    VARCHAR(100),
    AddressLine2    VARCHAR(100),
    AddressLine3    VARCHAR(100),
    LastUpdatedBy   VARCHAR(100),
    LastUpdated     TIMESTAMP           DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT pk_Warehouse PRIMARY KEY (WarehouseId)
);

INSERT INTO erp.Warehouse (WarehouseCode, WarehouseName, AddressLine1, AddressLine2, AddressLine3, LastUpdatedBy)
VALUES
('NL1', 'NL Warehouse 1', 'Warehouse Address Line 1', 'Warehouse Address Line 1', 'NL1 1NL', 'Jo'),
('NL2', 'NL Warehouse 2', 'Warehouse Address Line 2', 'Warehouse Address Line 2', 'NL2 2NL', 'Jo');

CREATE TABLE erp.StockLevel
(
    ProductId           INT,
    WarehouseId         INT,
    CurrentStockLevel   INT		GENERATED ALWAYS AS ((PhysicalStockLevel + DueStockLevel) - AllocatedStockLevel),
    DueStockLevel       INT,
    AllocatedStockLevel INT,
    PhysicalStockLevel  INT,
    LastUpdatedBy       VARCHAR(100),
    LastUpdated         TIMESTAMP        DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_StockLevel PRIMARY KEY (ProductId, WarehouseId)
);

CREATE TABLE erp.OrderStatus
(
    OrderStatusId   	INT             GENERATED ALWAYS AS IDENTITY,
    OrderStatus     	VARCHAR(20),
	LastUpdatedBy   	VARCHAR(100),
    LastUpdated         TIMESTAMP        DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT pk_OrderStatus PRIMARY KEY (OrderStatusId)
);

INSERT INTO erp.OrderStatus (OrderStatus, LastUpdatedBy)
VALUES
('In behandeling', 'Dolly'),
('Bevestigd', 'Dolly'),
('Geplukt', 'Dolly'),
('Openbaar Vervoer', 'Dolly'),
('Afgeleverd', 'Dolly'),
('Betaald', 'Dolly');

CREATE TABLE erp.SalesOrder
(
    SalesOrderId    INT             GENERATED ALWAYS AS IDENTITY,
    CustomerId      INT,
    OrderStatusId   INT,
    OurRef          VARCHAR(10),
    CustomerRef     VARCHAR(10),    
    OrderDate       TIMESTAMP,
    ConfirmedDate   TIMESTAMP,
	LastUpdatedBy   VARCHAR(100),
    LastUpdated     TIMESTAMP        DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE erp.SalesOrderLine
(
	SalesOrderLineId INT	PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    SalesOrderId	INT,
	WarehouseId		INT,
	ProductId		INT,
    Ordinal       	INT,
    Quantity        INT,
    ItemPrice 		MONEY,
	IsDiscounted	BOOLEAN,
    LineTotal  		MONEY GENERATED ALWAYS AS (Quantity * ItemPrice),
	LastUpdatedBy   VARCHAR(100),
    LastUpdated     TIMESTAMP        DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE erp.PurchaseOrder
(
    PurchaseOrderId INT             GENERATED ALWAYS AS IDENTITY,
    SupplierId      INT,
    OrderStatusId   INT,
    OurRef          VARCHAR(10),
    SupplierRef     VARCHAR(10),    
    OrderDate       TIMESTAMP,
    ConfirmedDate   TIMESTAMP,
    LastUpdatedBy   VARCHAR(100),
    LastUpdated     TIMESTAMP        DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE erp.PurchaseOrderLine
(
    PurchaseOrderLineId INT	PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    PurchaseOrderId	INT,
	WarehouseId		INT,
	ProductId		INT,
    Ordinal       	INT,
    Quantity        INT,
    ItemPrice 		MONEY,
	IsDiscounted	BOOLEAN,
    LineTotal  		MONEY GENERATED ALWAYS AS (Quantity * ItemPrice),
	LastUpdatedBy   VARCHAR(100),
    LastUpdated     TIMESTAMP        DEFAULT CURRENT_TIMESTAMP
);
