USE StockSystem;

GO

CREATE FUNCTION dbo.TotalOrderCost
(
 @OrderHeaderId	INT
)
RETURNS MONEY
AS
BEGIN;

DECLARE @Total	MONEY;

SELECT @Total = SUM(TotalLineCost)
	FROM dbo.OrderLine
WHERE OrderHeaderId = @OrderHeaderId;

RETURN @Total;

END;

GO