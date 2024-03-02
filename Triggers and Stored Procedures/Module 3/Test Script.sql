--select * from customer;

INSERT INTO OrderHeader (CustomerId, OrderReference)
VALUES 
(3, 'Adams1'),
(21, 'Potter2'),
(2, 'Potter1'),
(15, 'Formby1'),
(16, 'Partridge1'),
(23, 'Formby2'),
(24, 'Partridge2'),
(22, 'Adams2');

--SELECT * FROM dbo.OrderHeader;

--SELECT * FROM OrderHeader
--	WHERE CustomerId IN (2, 3, 15, 16, 21, 22, 23, 24);

SELECT * FROM dbo.AuditLog;
