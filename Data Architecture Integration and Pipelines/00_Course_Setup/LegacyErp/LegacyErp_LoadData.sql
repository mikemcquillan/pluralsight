-- Before running this script:
-- 1. Ensure the legacyerp files have been downloaded
-- 2. Ensure the legacyerp_createdb.sql database script has been executed.

-- To run this script:
-- 1. Open the script in SSMS.
-- 2. Click on Query menu, then SQLCMD Mode.
-- 3. Set the correct path in the variable on the :SETVAR line below.
--	  Ensure the value ends with a backslash \.
-- 4. Click on Execute or press F5 to load the data into the tables.

:SETVAR Path c:\sqlfiles\pipelinecourse\00_course_setup\legacyerp\
--C:\coursefiles\00_Course_Setup\LegacyErp\

USE LegacyERP;

DELETE FROM dbo.OrderLine;
DELETE FROM dbo.[Order];
DELETE FROM dbo.Contact;
DELETE FROM dbo.StockLevel;
DELETE FROM dbo.Item;

BULK INSERT dbo.Contact
FROM '$(Path)01_Customers.csv'
WITH
(
 FIRSTROW = 2,
 FIELDTERMINATOR = ','
);

BULK INSERT dbo.Contact
FROM '$(Path)02_Suppliers.csv'
WITH
(
 FIRSTROW = 2,
 FIELDTERMINATOR = ','
);

BULK INSERT dbo.Item
FROM '$(Path)03_Items.csv'
WITH
(
 FIRSTROW = 2,
 FIELDTERMINATOR = ','
);

BULK INSERT dbo.StockLevel
FROM '$(Path)04_StockLevel.csv'
WITH
(
 FIRSTROW = 2,
 FIELDTERMINATOR = ','
);

BULK INSERT dbo.[Order]
FROM '$(Path)05_SalesOrders.csv'
WITH
(
 FIRSTROW = 2,
 FIELDTERMINATOR = ','
);

BULK INSERT dbo.OrderLine
FROM '$(Path)06_SalesOrderLines.csv'
WITH
(
 FIRSTROW = 2,
 FIELDTERMINATOR = ','
);

BULK INSERT dbo.[Order]
FROM '$(Path)07_PurchaseOrders.csv'
WITH
(
 FIRSTROW = 2,
 FIELDTERMINATOR = ','
);

BULK INSERT dbo.OrderLine
FROM '$(Path)08_PurchaseOrderLines.csv'
WITH
(
 FIRSTROW = 2,
 FIELDTERMINATOR = ','
);

UPDATE dbo.Contact
	SET Postcode = REPLACE(REPLACE(Postcode, CHAR(13), ''), CHAR(10), '');

UPDATE OL
	SET OL.SingleItemPrice = I.Price
FROM dbo.OrderLine OL
	INNER JOIN dbo.Item I
		ON OL.ItemRef = I.ItemRef;