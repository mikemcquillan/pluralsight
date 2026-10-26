-- Before executing this script:
-- 1. Set the correct path on DECLARE base_path (line 16), ensuring the end back slash \ is specified.
-- To execute this script:
-- 1. Open a command prompt/terminal/shell.
-- 2. Type this command:

-- psql -U postgres -d newerpuk -f "C:\sqlfiles\NewErpNl_Import_Script.sql"

-- Change postgres to your user name, and the file path to wherever you have saved the file.
-- Press Enter to execute the command.
-- Enter your PostgreSQL account password.
-- The script will execute.

DO
$$
DECLARE base_path	VARCHAR(400) := 'C:\coursefiles\00_Course_Setup\NewErp\UK\';
		file_path	VARCHAR(400);
		sql_copy	VARCHAR(800);
BEGIN

	DELETE FROM erp.PurchaseOrderLine;
	DELETE FROM erp.PurchaseOrder;
	DELETE FROM erp.SalesOrderLine;
	DELETE FROM erp.SalesOrder;
	DELETE FROM erp.StockLevel;
	DELETE FROM erp.Customer;
	DELETE FROM erp.Supplier;
	DELETE FROM erp.Product;
	
	-- Copy customers
	file_path := '''' || base_path || '01_UK_Customers.csv' || '''';

	sql_copy := '
	COPY erp.Customer 
	(OurRef, CompanyName, CustomerName, TitleId, GenderId, 
	AddressLine1, AddresLine2, AddressLine3, LastUpdatedBy) 
	FROM ' || file_path || 
	' WITH CSV HEADER;';

	EXECUTE sql_copy;

	-- Copy suppliers
	file_path := '''' || base_path || '02_UK_Suppliers.csv' || '''';

	sql_copy := '
	COPY erp.Supplier
	(OurRef, CompanyName, PrimaryContact, 
	 AddressLine1, AddressLine2, AddressLine3, LastUpdatedBy)
	FROM ' || file_path || 
	' WITH CSV HEADER;';

	EXECUTE sql_copy;

	-- Copy products
	file_path := '''' || base_path || '03_UK_Products.csv' || '''';

	sql_copy := '
	COPY erp.Product
	(ProductCategoryId, ProductCode, ProductName, Price,
	 DiscountPercentage, LastUpdatedBy)
	FROM ' || file_path || 
	' WITH CSV HEADER;';

	EXECUTE sql_copy;

	-- Copy stock levels
	file_path := '''' || base_path || '04_UK_StockLevel.csv' || '''';

	sql_copy := '
	COPY erp.StockLevel
	(ProductId, WarehouseId, DueStockLevel, AllocatedStockLevel,
	 PhysicalStockLevel, LastUpdatedBy)
	FROM ' || file_path || 
	' WITH CSV HEADER;';

	EXECUTE sql_copy;

	-- Copy sales orders
	file_path := '''' || base_path || '05_UK_SalesOrders.csv' || '''';

	sql_copy := '
	COPY erp.SalesOrder
	(SalesOrderId, CustomerId, OrderStatusId, OurRef, CustomerRef,
	 OrderDate, ConfirmedDate, LastUpdatedBy)
	FROM ' || file_path || 
	' WITH CSV HEADER;';

	EXECUTE sql_copy;

	-- Copy sales order lines
	file_path := '''' || base_path || '06_UK_SalesOrderLines.csv' || '''';

	sql_copy := '
	COPY erp.SalesOrderLine
	(SalesOrderLineId, SalesOrderId, WarehouseId, ProductId,
	 Ordinal, Quantity, ItemPrice, IsDiscounted, LastUpdatedBy)
	FROM ' || file_path || 
	' WITH CSV HEADER;';

	EXECUTE sql_copy;

	UPDATE erp.SalesOrderLine SOL
		SET ItemPrice = P.Price
	FROM erp.Product P
		WHERE SOL.ProductId = P.ProductId;

	-- Copy purchase orders
	file_path := '''' || base_path || '07_UK_PurchaseOrders.csv' || '''';

	sql_copy := '
	COPY erp.PurchaseOrder
	(PurchaseOrderId, SupplierId, OrderStatusId, OurRef, SupplierRef,
	 OrderDate, ConfirmedDate, LastUpdatedBy)
	FROM ' || file_path || 
	' WITH CSV HEADER;';

	EXECUTE sql_copy;

	-- Copy purchase order lines
	file_path := '''' || base_path || '08_UK_PurchaseOrderLines.csv' || '''';

	sql_copy := '
	COPY erp.PurchaseOrderLine
	(PurchaseOrderLineId, PurchaseOrderId, WarehouseId, ProductId,
	 Ordinal, Quantity, IsDiscounted, ItemPrice, LastUpdatedBy)
	FROM ' || file_path || 
	' WITH CSV HEADER;';

	EXECUTE sql_copy;

	UPDATE erp.PurchaseOrderLine POL
		SET ItemPrice = P.Price
	FROM erp.Product P
	WHERE POL.productId = P.ProductId;

	UPDATE erp.customer
		SET genderid = 2
	WHERE customerid % 2 = 0;

	UPDATE erp.customer
		SET genderid = 1
	WHERE customerid % 2 != 0;

	UPDATE erp.customer
		SET titleid = 1
	WHERE genderid = 1;

	UPDATE erp.customer
		SET titleid = 3
	WHERE genderid = 2;

END
$$;