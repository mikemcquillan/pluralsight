-- To run this script, open the script in SSMS, then execute the script to create the database.

USE master;

IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE [name] = 'LegacyErp')
BEGIN;
   CREATE DATABASE LegacyErp;
END;

GO

USE LegacyErp;

CREATE TABLE dbo.Contact
(
    ContactRef		VARCHAR(10)     PRIMARY KEY,
	ContactType		VARCHAR(1),
    CompanyName     VARCHAR(50),
    FirstName       VARCHAR(50),
    LastName        VARCHAR(50),
    Title           VARCHAR(20),
    Gender          VARCHAR(20),
    AddressLine1    VARCHAR(100),
    City            VARCHAR(100),
    Postcode        VARCHAR(100)
);

CREATE TABLE dbo.ItemType
(
	ItemTypeRef		VARCHAR(20)		PRIMARY KEY,
	ItemType		VARCHAR(30)
);

SET NOCOUNT ON;
INSERT INTO dbo.ItemType (ItemTypeRef, ItemType)
VALUES
('Car1', 'Car'),
('Cara1', 'Caravan'),
('Golf1', 'Golf'),
('Fork1', 'Forklift');
SET NOCOUNT OFF;

CREATE TABLE dbo.Item
(
    ItemRef         VARCHAR(10)     PRIMARY KEY,
    ItemTypeRef     VARCHAR(20),
    ItemName        VARCHAR(100),
    Price           MONEY
);

CREATE TABLE dbo.Warehouse
(
    WarehouseRef    VARCHAR(10)     PRIMARY KEY,
    WarehouseName   VARCHAR(100)
);

INSERT INTO dbo.Warehouse (WarehouseRef, WarehouseName)
VALUES
('UK1', 'UK Warehouse 1'),
('UK2', 'UK Warehouse 2'),
('UK3', 'UK Warehouse 3'),
('UK4', 'UK Warehouse 4'),
('UK5', 'UK Warehouse 5'),
('UK6', 'UK Warehouse 6'),
('UK7', 'UK Warehouse 7'),
('US1', 'US Warehouse 1'),
('US2', 'US Warehouse 2'),
('US3', 'US Warehouse 3'),
('NL1', 'NL Warehouse 1'),
('NL2', 'NL Warehouse 2');

CREATE TABLE dbo.StockLevel
(
    ItemRef         VARCHAR(10),
    WarehouseRef    VARCHAR(10),
    StockLevel      INT,
    CONSTRAINT pk_StockLevel PRIMARY KEY (ItemRef, WarehouseRef)
);

CREATE TABLE dbo.[Order]
(
    OrderRef        VARCHAR(10)     PRIMARY KEY,
	OrderType		VARCHAR(1),
    OrderDate       DATE,
    SentDate        DATE,
    ContactRef		VARCHAR(10),
    DueDate         DATE
);

CREATE TABLE dbo.OrderLine
(
    OrderRef        VARCHAR(10),
    OrderLine       INT,
    ItemRef         VARCHAR(10),
    Quantity        INT,
    SingleItemPrice MONEY,
    TotalLinePrice  AS (Quantity * SingleItemPrice)
);

ALTER TABLE dbo.Item
    ADD CONSTRAINT fk_Item_ItemType
        FOREIGN KEY (ItemTypeRef)
        REFERENCES dbo.ItemType(ItemTypeRef);

ALTER TABLE dbo.StockLevel
    ADD CONSTRAINT fk_StockLevel_Item
        FOREIGN KEY (ItemRef)
        REFERENCES dbo.Item(ItemRef);

ALTER TABLE dbo.StockLevel
    ADD CONSTRAINT fk_StockLevel_Warehouse
        FOREIGN KEY (WarehouseRef)
        REFERENCES dbo.Warehouse(WarehouseRef);

ALTER TABLE dbo.[Order]
    ADD CONSTRAINT fk_Order_Contact
        FOREIGN KEY (ContactRef)
        REFERENCES dbo.Contact(ContactRef);

ALTER TABLE dbo.OrderLine
    ADD CONSTRAINT fk_OrderLine_Order
        FOREIGN KEY (OrderRef)
        REFERENCES dbo.[Order](OrderRef);

ALTER TABLE dbo.OrderLine
    ADD CONSTRAINT fk_OrderLine_Item
        FOREIGN KEY (ItemRef)
        REFERENCES dbo.Item(ItemRef);