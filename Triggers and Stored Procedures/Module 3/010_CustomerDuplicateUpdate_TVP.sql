USE StockSystem;

GO

IF EXISTS(SELECT 1 FROM sys.table_types WHERE [name] = 'CustomerDuplicateUpdate')
 BEGIN;
	DROP TYPE dbo.CustomerDuplicateUpdate;
 END;

GO

CREATE TYPE dbo.CustomerDuplicateUpdate
AS TABLE
(
 CustomerName	VARCHAR(200), 
 HasDuplicate	BIT, 
 CorrectId		INT
);

GO