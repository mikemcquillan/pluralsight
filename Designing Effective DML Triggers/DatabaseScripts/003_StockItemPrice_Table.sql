USE [StockSystem]

GO

CREATE TABLE dbo.StockItemPrice
(
 StockItemPriceId	INT IDENTITY(1,1)	NOT NULL,
 StockItemId		INT					NOT NULL,
 ItemPrice			MONEY				NOT NULL,
 StartDate			DATE				NOT NULL,
 EndDate			DATE				NULL,
 CONSTRAINT pk_StockItemPrice PRIMARY KEY CLUSTERED (StockItemPriceId)
) 
ON [PRIMARY];

GO

ALTER TABLE dbo.StockItemPrice  
ADD CONSTRAINT fk_StockItem_StockItemPrice 
	FOREIGN KEY(StockItemId)
	REFERENCES dbo.StockItem (StockItemId)
	ON UPDATE NO ACTION
	ON DELETE NO ACTION;

GO


