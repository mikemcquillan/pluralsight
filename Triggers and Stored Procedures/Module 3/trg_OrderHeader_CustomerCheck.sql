USE StockSystem;

GO

-- 1. Check if this is the only version of the customer.
-- 2. If only version, nothing else to do.
-- 3. If there is an active duplicate, check if this is the latest version of the customer.
-- 4. If this is the latest version, close off duplicates.
-- 5. If this is not the latest version, update all orders for the old versions to use the latest customer, then close off the duplicates.
ALTER TRIGGER trg_OrderHeader_CustomerCheck
ON dbo.OrderHeader
AFTER INSERT
AS
BEGIN;

DECLARE @CustomerNames			TABLE (CustomerName VARCHAR(200), HasDuplicate BIT, LatestId INT);
DECLARE @UpdatedOrderHeaders	TABLE (OrderHeaderId INT, OldCustomerId INT, NewCustomerId INT);

INSERT INTO @CustomerNames (CustomerName, LatestId)
	SELECT C.CustomerName, MAX(C.CustomerId)
		FROM dbo.Customer C
	WHERE C.IsActive = 1
		AND C.CustomerName IN (SELECT C.CustomerName FROM dbo.Customer C INNER JOIN inserted I ON C.CustomerId = I.CustomerId)
GROUP BY C.CustomerName;

--SELECT	C.CustomerId,
--		C.CustomerName,
--		1 AS Duplicate,
--		CN.LatestId AS IdToUpdateTo,
--		OH.OrderHeaderId
--FROM dbo.Customer C
--	INNER JOIN inserted I
--		ON C.CustomerId = I.CustomerId
--	INNER JOIN @CustomerNames CN
--		ON C.CustomerName = CN.CustomerName
--	INNER JOIN dbo.OrderHeader OH
--		ON C.CustomerId = OH.CustomerId
--WHERE C.CustomerId != CN.LatestId

UPDATE OH
	SET OH.CustomerId = CN.LatestId
OUTPUT DELETED.OrderHeaderId, DELETED.CustomerId, INSERTED.CustomerId
	INTO @UpdatedOrderHeaders
FROM dbo.Customer C
	INNER JOIN inserted I
		ON C.CustomerId = I.CustomerId
	INNER JOIN @CustomerNames CN
		ON C.CustomerName = CN.CustomerName
	INNER JOIN dbo.OrderHeader OH
		ON C.CustomerId = OH.CustomerId
WHERE C.CustomerId != CN.LatestId;

UPDATE C
	SET C.IsActive = 0
FROM @UpdatedOrderHeaders UOH
	INNER JOIN dbo.Customer C
		ON UOH.OldCustomerId = C.CustomerId;

INSERT INTO dbo.AuditLog
	(RecordType, RecordId, ChangeNotes, UpdatedDate, UpdatedBy)
SELECT	'OrderHeader',
		UOH.OrderHeaderId,
		'Duplicate customer ID. Changed from ' + CONVERT(VARCHAR(10), UOH.OldCustomerId) + ' to ' + CONVERT(VARCHAR(10), UOH.NewCustomerId) + '.',
		GETDATE(),
		USER_NAME()
FROM @UpdatedOrderHeaders UOH;

INSERT INTO dbo.AuditLog
	(RecordType, RecordId, ChangeNotes, UpdatedDate, UpdatedBy)
SELECT	'Customer',
		UOH.OldCustomerId,
		'Customer is a duplicate. Marked as inactive.',
		GETDATE(),
		USER_NAME()
FROM @UpdatedOrderHeaders UOH;

END;