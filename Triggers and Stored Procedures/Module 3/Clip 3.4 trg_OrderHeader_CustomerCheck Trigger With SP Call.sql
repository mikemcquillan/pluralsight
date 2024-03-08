USE StockSystem;

GO

IF EXISTS(SELECT 1 FROM sys.triggers WHERE [name] = 'trg_OrderHeader_CustomerCheck')
 BEGIN;
	DROP TRIGGER trg_OrderHeader_CustomerCheck;
 END;

GO

-- 1. Check if this is the only version of the customer.
-- 2. If only version, nothing else to do.
-- 3. If there is an active duplicate, check if this is the latest version of the customer.
-- 4. If this is the latest version, close off duplicates.
-- 5. If this is not the latest version, update all orders for the old versions to use the latest customer, then close off the duplicates.
-- 6. Audit actions taken.
CREATE TRIGGER trg_OrderHeader_CustomerCheck
ON dbo.OrderHeader
AFTER INSERT
AS
BEGIN;

IF (@@ROWCOUNT = 0) RETURN;
IF NOT EXISTS (SELECT 1 FROM inserted UNION ALL SELECT 1 FROM deleted) RETURN;

SET NOCOUNT ON;

DECLARE @CustomerNames			dbo.CustomerDuplicateUpdate;

-- Obtain last active version of the customers on the orders being inserted, using the largest customer ID
INSERT INTO @CustomerNames (CustomerName, CorrectId)
	SELECT C.CustomerName, MAX(C.CustomerId)
		FROM dbo.Customer C
	WHERE C.IsActive = 1
		AND C.CustomerName IN (SELECT C.CustomerName FROM dbo.Customer C INNER JOIN inserted I ON C.CustomerId = I.CustomerId)
GROUP BY C.CustomerName;

EXEC dbo.ProcessDuplicateCustomers
	@CustomersToUpdate = @CustomerNames;

SET NOCOUNT OFF;

END;

GO