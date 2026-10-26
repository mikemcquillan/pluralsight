-- To execute this script:
-- 1. Open a command prompt/terminal/shell.
-- 2. Type this command:

-- psql -U postgres -f "C:\sqlfiles\NewErpUk_CreateDb.sql"

-- Change postgres to your user name, and the file path to wherever you have saved the file.
-- Press Enter to execute the command.
-- Enter your PostgreSQL account password.
-- The script will execute.

DROP DATABASE IF EXISTS NewErpUk;

SELECT 'CREATE DATABASE NewErpUk'
WHERE NOT EXISTS (
    SELECT FROM pg_database
    WHERE datname = 'newerpuk'
)\gexec

\connect newerpuk

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
('Male', 'Bertie'),
('Female', 'Bertie'),
('Not Specified', 'Bertie');

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
('Mister', 'Jo'),
('Sir', 'Jo'),
('Mrs', 'Jo'),
('Miss', 'Jo'),
('Ms', 'Jo'),
('Madam', 'Jo'),
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
('Car', 'Cars & Vehicles', 'Bob'),
('Caravan', 'Caravans', 'Terry'),
('Golf', 'Golf Carts', 'Bertie'),
('Fork', 'Forklift Trucks', 'Dolly'),
('Truck', 'Trucks', 'Grace'),
('Lorry', 'Lorries', 'Jo');

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
('UK1', 'UK Warehouse 1', 'Warehouse Address Line 1', 'Warehouse Address Line 1', 'UK1 1UK', 'Jo'),
('UK2', 'UK Warehouse 2', 'Warehouse Address Line 2', 'Warehouse Address Line 2', 'UK2 2UK', 'Jo'),
('UK3', 'UK Warehouse 3', 'Warehouse Address Line 3', 'Warehouse Address Line 3', 'UK3 4UK', 'Jo'),
('UK4', 'UK Warehouse 4', 'Warehouse Address Line 4', 'Warehouse Address Line 4', 'UK4 4UK', 'Grace'),
('UK5', 'UK Warehouse 5', 'Warehouse Address Line 5', 'Warehouse Address Line 5', 'UK5 5UK', 'Dolly'),
('UK6', 'UK Warehouse 6', 'Warehouse Address Line 6', 'Warehouse Address Line 6', 'UK6 6UK', 'Bertie'),
('UK7', 'UK Warehouse 7', 'Warehouse Address Line 7', 'Warehouse Address Line 7', 'UK7 7UK', 'Bertie');

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
('Pending', 'Dolly'),
('Confirmed', 'Dolly'),
('Picked', 'Dolly'),
('In Transit', 'Dolly'),
('Delivered', 'Dolly'),
('Paid', 'Dolly');

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
