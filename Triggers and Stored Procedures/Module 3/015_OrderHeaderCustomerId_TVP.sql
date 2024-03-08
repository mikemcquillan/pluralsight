USE StockSystem;

GO

IF EXISTS(SELECT 1 FROM sys.table_types WHERE [name] = 'OrderHeaderCustomerId')
 BEGIN;
	DROP TYPE dbo.OrderHeaderCustomerId;
 END;

GO

CREATE TYPE dbo.OrderHeaderCustomerId
AS TABLE
(
 OrderHeaderId		INT,
 OldCustomerId		INT,
 NewCustomerId		INT
);

GO