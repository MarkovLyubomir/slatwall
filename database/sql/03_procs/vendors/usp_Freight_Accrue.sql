/* =============================================================================
   Procedure: dbo.usp_Freight_Accrue
   Author:    Wade Hollister
   Created:   2016-01-11
   Purpose:   Month-end freight accrual by DC/lane (the Access FreightAccrual
              workbook logic). Outbound delivery cost uses the same zone fee
              table as fn_Delivery_ZoneFee, re-typed here with 2016 numbers.
   Change log:
     2016-01-11  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Freight_Accrue', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Freight_Accrue
GO
CREATE PROCEDURE dbo.usp_Freight_Accrue
    @periodYYYYMM CHAR(6)
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @from DATE, @to DATE
    SET @from = DATEFROMPARTS(CAST(LEFT(@periodYYYYMM, 4) AS INT), CAST(RIGHT(@periodYYYYMM, 2) AS INT), 1)
    SET @to = EOMONTH(@from)
    DELETE dbo.tblFreightAccrual WHERE PeriodYYYYMM = @periodYYYYMM AND ISNULL(Posted, 0) = 0

    -- outbound: our fleet, estimated by zone
    INSERT dbo.tblFreightAccrual (PeriodYYYYMM, Carrier, DC, Lane, EstFreight, ActualFreight, Variance, Posted, GLAcct)
    SELECT @periodYYYYMM, 'FLEET', ISNULL(CAST(sp.StoreNumber AS VARCHAR(5)), 'KNV'), ISNULL(ds.FeeCode, 'ZB'),
           SUM(CASE REPLACE(ds.FeeCode, 'Z', '') WHEN 'A' THEN 42.00 WHEN 'B' THEN 68.00 WHEN 'C' THEN 105.00 ELSE 140.00 END + CASE WHEN ds.BoomRequired = 1 THEN 85.00 ELSE 0 END),
           NULL, NULL, 0, '5210-FRT'
    FROM dbo.SwDeliveryStop ds JOIN dbo.SwOrder o ON o.orderID = ds.orderID LEFT JOIN dbo.SwStoreProfile sp ON sp.locationID = o.locationID
    WHERE ds.CompletedOn BETWEEN @from AND @to
    GROUP BY sp.StoreNumber, ds.FeeCode

    -- inbound: carrier from ASN, flat 3.2% of received cost (Controller's rule)
    INSERT dbo.tblFreightAccrual (PeriodYYYYMM, Carrier, DC, Lane, EstFreight, Posted, GLAcct)
    SELECT @periodYYYYMM, ISNULL(a.Carrier, 'UNKNOWN'), ISNULL(a.DCCode, 'KNV'), 'INBOUND', SUM(sri.quantity * sri.cost) * 0.032, 0, '5211-FRTIN'
    FROM dbo.SwStockReceiverItem sri JOIN dbo.SwStockReceiver sr ON sr.stockReceiverID = sri.stockReceiverID
    LEFT JOIN dbo.SwASN a ON a.vendorOrderID = sr.vendorOrderID
    WHERE sri.createdDateTime BETWEEN @from AND @to AND sr.vendorOrderID IS NOT NULL
    GROUP BY a.Carrier, a.DCCode
END
GO
