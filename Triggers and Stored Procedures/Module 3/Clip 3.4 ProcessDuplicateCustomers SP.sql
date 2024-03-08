USE StockSystem;

GO

CREATE PROCEDURE dbo.ProcessDuplicateCustomers
(
 @CustomersToUpdate		dbo.CustomerDuplicateUpdate READONLY
)
AS
BEGIN;

SET NOCOUNT ON;

DECLARE @UpdatedOrderHeaders	dbo.OrderHeaderCustomerId,
		@DeactivatedCustomers	dbo.OrderHeaderCustomerId,
		@AuditLog				dbo.AuditLogEntry;

-- Update order headers to correct customer, using OUTPUT to grab data for audit
UPDATE OH
	SET OH.CustomerId = CU.CorrectId
OUTPUT DELETED.OrderHeaderId, DELETED.CustomerId, INSERTED.CustomerId
	INTO @UpdatedOrderHeaders
FROM dbo.Customer C
	INNER JOIN @CustomersToUpdate CU
		ON C.CustomerName = CU.CustomerName
	INNER JOIN dbo.OrderHeader OH
		ON C.CustomerId = OH.CustomerId
WHERE C.CustomerId != CU.CorrectId;

-- Deactivate all old versions of customer which are currently active
UPDATE C
	SET C.IsActive = 0
OUTPUT NULL, DELETED.CustomerId, NULL
INTO @DeactivatedCustomers
FROM @UpdatedOrderHeaders UOH
	INNER JOIN dbo.Customer C
		ON UOH.OldCustomerId = C.CustomerId
WHERE C.IsActive = 1;

-- Log the changes made to order headers
INSERT INTO @AuditLog
	(RecordType, RecordId, ChangeNotes, UpdatedDate, UpdatedBy)
SELECT	'OrderHeader',
		UOH.OrderHeaderId,
		'Duplicate customer ID. Changed from ' + CONVERT(VARCHAR(10), UOH.OldCustomerId) + ' to ' + CONVERT(VARCHAR(10), UOH.NewCustomerId) + '.',
		GETDATE(),
		USER_NAME()
FROM @UpdatedOrderHeaders UOH;

-- Log the changes made to customers
INSERT INTO @AuditLog
	(RecordType, RecordId, ChangeNotes, UpdatedDate, UpdatedBy)
SELECT	DISTINCT
		'Customer',
		DC.OldCustomerId,
		'Customer is a duplicate. Marked as inactive.',
		GETDATE(),
		USER_NAME()
	FROM @DeactivatedCustomers DC;

EXEC dbo.InsertAuditLogEntries 
	@AuditLogEntries = @AuditLog;

SET NOCOUNT OFF;

END;