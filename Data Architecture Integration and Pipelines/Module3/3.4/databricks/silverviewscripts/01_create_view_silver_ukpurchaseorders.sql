CREATE VIEW globodata.silver.vwUKPurchaseOrders
AS
SELECT  PO.SystemPurchaseOrderId AS PurchaseOrderId,
        PO.OrderStatus,
        PO.OurReference,
        PO.SupplierReference,
        PO.OrderDate,
        S.CompanyName AS SupplierName,
        SUM(POL.LineTotal) AS OrderValue
  FROM globodata.silver.purchaseorder PO
    INNER JOIN globodata.silver.purchaseorderline POL
      ON PO.SourceSystem = POL.SourceSystem
        AND PO.Country = POL.Country
        AND PO.SystemPurchaseOrderId = POL.SystemPurchaseOrderId
    INNER JOIN globodata.silver.supplier S
      ON PO.SourceSystem = S.SourceSystem
        AND PO.Country = S.Country
        AND PO.SystemSupplierId = S.SystemSupplierId
WHERE PO.Country = 'UK'
GROUP BY PO.SystemPurchaseOrderId,
         PO.OrderStatus,
         PO.OurReference,
         PO.SupplierReference,
         PO.OrderDate,
         S.CompanyName;