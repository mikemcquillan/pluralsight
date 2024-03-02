USE StockSystem;

GO

CREATE TABLE dbo.OrderHeader
(
 OrderHeaderId		INT IDENTITY(1,1)	NOT NULL,
 CustomerId			INT					NOT NULL,
 OrderReference		VARCHAR(20)			NOT NULL,
 OrderDate			DATETIME			NOT NULL CONSTRAINT df_OrderHeader_OrderDate DEFAULT (GETDATE()),
 TotalCost			AS dbo.TotalOrderCost(OrderHeaderId),
 CONSTRAINT pk_OrderHeader PRIMARY KEY CLUSTERED (OrderHeaderId)
);

GO

ALTER TABLE dbo.OrderHeader
	ADD CONSTRAINT fk_OrderHeader_Customer FOREIGN KEY (CustomerId)
		REFERENCES Customer (CustomerId)
		ON UPDATE NO ACTION
		ON DELETE NO ACTION;

GO