USE StockSystem;

GO

CREATE TABLE dbo.OrderLine
(
 OrderLineId		INT IDENTITY(1,1)	NOT NULL,
 OrderHeaderId		INT					NOT NULL,
 StockItemId		INT					NOT NULL,
 Quantity			INT					NOT NULL,
 ItemCost			MONEY				NOT NULL,
 TotalLineCost		AS (Quantity * ItemCost),
 CONSTRAINT pk_OrderLine PRIMARY KEY CLUSTERED (OrderLineId)
);

GO

ALTER TABLE dbo.OrderLine
	ADD CONSTRAINT fk_OrderLine_Order FOREIGN KEY (OrderHeaderId)
		REFERENCES dbo.OrderHeader (OrderHeaderId)
			ON UPDATE NO ACTION
			ON DELETE NO ACTION;

GO

ALTER TABLE dbo.OrderLine
	ADD CONSTRAINT fk_OrderLine_StockItem FOREIGN KEY (StockItemid)
		REFERENCES dbo.StockItem (StockItemId)
			ON UPDATE NO ACTION
			ON DELETE NO ACTION;

GO