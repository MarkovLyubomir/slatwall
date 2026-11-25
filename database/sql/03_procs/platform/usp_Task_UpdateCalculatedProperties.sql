/* =============================================================================
   Procedure: dbo.usp_Task_UpdateCalculatedProperties
   Author:    Wade Hollister
   Created:   2014-07-30
   Purpose:   Slatwall "update calculated properties" task: product/sku QATS and
              product sale price rollups. Partially duplicated by usp_Batch_RecalcStock.
   Change log:
     2014-07-30  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Task_UpdateCalculatedProperties', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Task_UpdateCalculatedProperties
GO
CREATE PROCEDURE dbo.usp_Task_UpdateCalculatedProperties
AS
BEGIN
    SET NOCOUNT ON
    UPDATE s SET s.calculatedQATS = x.q FROM dbo.SwSku s JOIN (SELECT skuID, SUM(calculatedQATS) AS q FROM dbo.SwStock GROUP BY skuID) x ON x.skuID = s.skuID
    UPDATE p SET p.calculatedQATS = x.q, p.calculatedSalePrice = x.minPrice, p.calculatedAllowBackorderFlag = 0
    FROM dbo.SwProduct p JOIN (SELECT productID, SUM(calculatedQATS) AS q, MIN(price) AS minPrice FROM dbo.SwSku WHERE activeFlag = 1 GROUP BY productID) x ON x.productID = p.productID
    UPDATE g SET g.calculatedBalanceAmount = ISNULL(x.bal, 0) FROM dbo.SwGiftCard g LEFT JOIN (SELECT giftCardID, SUM(ISNULL(creditAmount, 0) - ISNULL(debitAmount, 0)) AS bal FROM dbo.SwGiftCardTransaction GROUP BY giftCardID) x ON x.giftCardID = g.giftCardID
END
GO
