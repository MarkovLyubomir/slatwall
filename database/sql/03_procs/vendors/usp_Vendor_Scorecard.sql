/* =============================================================================
   Procedure: dbo.usp_Vendor_Scorecard
   Author:    Wade Hollister
   Created:   2022-08-15
   Purpose:   Period vendor scorecard (LEG-110 schedule C): fill rate, on-time,
              chargebacks, price-change notices. Score weights hard-coded.
   Change log:
     2022-08-15  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Vendor_Scorecard', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Vendor_Scorecard
GO
CREATE PROCEDURE dbo.usp_Vendor_Scorecard
    @fiscalYear SMALLINT,
    @fiscalPeriod TINYINT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @from DATE, @to DATE
    SELECT @from = MIN(CalendarDate), @to = MAX(CalendarDate) FROM dbo.SwFiscalCalendar WHERE FiscalYear = @fiscalYear AND FiscalPeriod = @fiscalPeriod
    DELETE dbo.SwVendorScorecard WHERE FiscalYear = @fiscalYear AND FiscalPeriod = @fiscalPeriod

    INSERT dbo.SwVendorScorecard (vendorID, FiscalYear, FiscalPeriod, POCount, LinesOrdered, LinesFilled, FillRatePct, OnTimePct, ChargebackCount, ChargebackAmt, Score, Grade, CalculatedOn)
    SELECT v.vendorID, @fiscalYear, @fiscalPeriod,
           COUNT(DISTINCT vo.vendorOrderID), COUNT(voi.vendorOrderItemID),
           SUM(CASE WHEN ISNULL(r.received, 0) >= voi.quantity THEN 1 ELSE 0 END),
           CASE WHEN COUNT(voi.vendorOrderItemID) > 0 THEN ROUND(100.0 * SUM(CASE WHEN ISNULL(r.received, 0) >= voi.quantity THEN 1 ELSE 0 END) / COUNT(voi.vendorOrderItemID), 2) END,
           CASE WHEN COUNT(DISTINCT vo.vendorOrderID) > 0 THEN ROUND(100.0 * COUNT(DISTINCT CASE WHEN r.firstReceived <= vo.estimatedReceivalDateTime THEN vo.vendorOrderID END) / COUNT(DISTINCT vo.vendorOrderID), 2) END,
           ISNULL(cb.cnt, 0), ISNULL(cb.amt, 0), NULL, NULL, GETDATE()
    FROM dbo.SwVendor v
    JOIN dbo.SwVendorOrder vo ON vo.vendorID = v.vendorID AND vo.createdDateTime BETWEEN @from AND @to
    JOIN dbo.SwVendorOrderItem voi ON voi.vendorOrderID = vo.vendorOrderID
    LEFT JOIN (SELECT vendorOrderItemID, SUM(quantity) AS received, MIN(createdDateTime) AS firstReceived FROM dbo.SwStockReceiverItem GROUP BY vendorOrderItemID) r ON r.vendorOrderItemID = voi.vendorOrderItemID
    LEFT JOIN (SELECT vo2.vendorID, COUNT(*) AS cnt, SUM(re.ChargebackAmt) AS amt FROM dbo.SwReceivingException re JOIN dbo.SwStockReceiverItem sri ON sri.stockReceiverItemID = re.stockReceiverItemID
               JOIN dbo.SwStockReceiver sr ON sr.stockReceiverID = sri.stockReceiverID JOIN dbo.SwVendorOrder vo2 ON vo2.vendorOrderID = sr.vendorOrderID
               WHERE re.ChargebackFlag = 1 AND re.RaisedOn BETWEEN @from AND @to GROUP BY vo2.vendorID) cb ON cb.vendorID = v.vendorID
    GROUP BY v.vendorID, cb.cnt, cb.amt

    UPDATE dbo.SwVendorScorecard SET Score = ROUND(ISNULL(FillRatePct, 0) * 0.5 + ISNULL(OnTimePct, 0) * 0.35 + (100 - CASE WHEN ChargebackCount > 15 THEN 100 ELSE ChargebackCount * 6.67 END) * 0.15, 2)
    WHERE FiscalYear = @fiscalYear AND FiscalPeriod = @fiscalPeriod
    UPDATE dbo.SwVendorScorecard SET Grade = CASE WHEN Score >= 95 THEN 'A' WHEN Score >= 88 THEN 'B' WHEN Score >= 80 THEN 'C' ELSE 'D' END WHERE FiscalYear = @fiscalYear AND FiscalPeriod = @fiscalPeriod
END
GO
