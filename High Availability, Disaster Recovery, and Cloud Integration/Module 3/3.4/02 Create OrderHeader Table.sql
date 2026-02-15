CREATE TABLE dbo.OrderHeader
(
 OrderHeaderId	INT IDENTITY(1,1) NOT NULL,
 CustomerId		INT NOT NULL,
 OrderReference VARCHAR(20) NOT NULL,
 OrderDate		DATETIME NOT NULL,
 TotalCost		MONEY NOT NULL,
 CONSTRAINT pk_OrderHeader PRIMARY KEY CLUSTERED (OrderHeaderId)
);

GO

ALTER TABLE dbo.OrderHeader ADD CONSTRAINT df_OrderHeader_OrderDate DEFAULT (GETDATE()) FOR OrderDate;

GO

ALTER TABLE dbo.OrderHeader WITH CHECK ADD CONSTRAINT fk_OrderHeader_Customer FOREIGN KEY(CustomerId)
	REFERENCES dbo.Customer (CustomerId);

GO

ALTER TABLE dbo.OrderHeader CHECK CONSTRAINT fk_OrderHeader_Customer;

GO