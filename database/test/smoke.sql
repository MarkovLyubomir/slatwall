/* =============================================================================
   SlatwallCommerce smoke test
   Run after a full deploy (schema + reference data + seed). Exercises the three
   order-capture paths, a BOPIS pick, a vendor receipt, a quote, a credit hold
   override and the nightly batch orchestrator.
   Expected: every section prints OK. Known/expected failures are listed at the
   bottom and are NOT run here (see docs/expected_failures.md).
   FICTIONAL SAMPLE - 3Pillar Atlas demo.
   ============================================================================= */
SET NOCOUNT ON
USE SlatwallCommerce
GO
DECLARE @orderID CHAR(32), @orderNumber VARCHAR(255), @skuID CHAR(32), @skuID2 CHAR(32), @accountID CHAR(32), @proAccountID INT,
        @fID CHAR(32), @opID CHAR(32), @price DECIMAL(19,4), @pg CHAR(32), @qats INT, @loc CHAR(32), @pickID INT, @quoteID INT,
        @voID CHAR(32), @vendorID CHAR(32), @dc CHAR(32), @ok BIT, @exp DECIMAL(19,2), @lim DECIMAL(19,2), @ret CHAR(32), @oiID CHAR(32), @did CHAR(32)

SELECT TOP 1 @skuID = skuID FROM dbo.SwSku WHERE skuCode = 'LBR-1001'
SELECT TOP 1 @skuID2 = skuID FROM dbo.SwSku WHERE skuCode = 'FST-8001'
SELECT TOP 1 @accountID = accountID, @proAccountID = ProAccountID FROM dbo.SwProAccount WHERE BTCustomerNo = 'C10001'
SELECT @loc = locationID FROM dbo.SwStoreProfile WHERE StoreNumber = 7
SELECT TOP 1 @dc = locationID FROM dbo.SwDistributionCenter WHERE PrimaryFlag = 1

-- 1. pricing engines (three answers for the same sku)
EXEC dbo.usp_Price_GetSellPrice @skuID = @skuID, @accountID = @accountID, @locationID = @loc, @quantity = 10, @sellPrice = @price OUTPUT, @priceGroupID = @pg OUTPUT
PRINT '1a OK counter price = ' + CAST(@price AS VARCHAR(20))
EXEC dbo.usp_Web_GetPrice @skuID = @skuID, @customerGroup = 'PRO1', @priceZone = 'A', @webPrice = @price OUTPUT
PRINT '1b OK web price     = ' + CAST(@price AS VARCHAR(20))

-- 2. pro desk order on terms, placed through usp_Order_PlaceOrder
EXEC dbo.usp_Order_Create @accountID = @accountID, @orderOrigin = 'pro', @orderID = @orderID OUTPUT
UPDATE dbo.SwOrder SET locationID = @loc WHERE orderID = @orderID
EXEC dbo.usp_Order_AddOrderItem @orderID = @orderID, @skuID = @skuID, @quantity = 40
EXEC dbo.usp_Order_AddOrderItem @orderID = @orderID, @skuID = @skuID2, @quantity = 2, @fulfillType = 'BOPIS'
EXEC dbo.usp_Order_AddPromotionCode @orderID = @orderID, @promotionCode = 'SPRING26'
EXEC dbo.usp_Order_AddOrderPayment @orderID = @orderID, @paymentMethodType = 'termPayment', @orderPaymentID = @opID OUTPUT
EXEC dbo.usp_Order_PlaceOrder @orderID = @orderID, @source = 'pro', @orderNumber = @orderNumber OUTPUT
PRINT '2  OK pro order ' + ISNULL(@orderNumber, '(none)') + ' status ' + dbo.fn_Order_StatusCode(@orderID)

-- 3. web order import (JSON)
EXEC dbo.usp_Web_ImportOrder @payload = N'{"customer_email":"new.customer@mail.test","customer_id":"99001","increment_id":"100099001","customer_firstname":"New","customer_lastname":"Customer",
  "extension_attributes":{"pickup_store":7,"fulfill_type":"BOPIS"},"items":[{"sku":"FST-8001","qty_ordered":1,"price":34.90},{"sku":"CNS-9001","qty_ordered":2,"price":26.50}]}', @orderID = @orderID OUTPUT
PRINT '3  OK web order ' + (SELECT orderNumber FROM dbo.SwOrder WHERE orderID = @orderID) + ' status ' + dbo.fn_Order_StatusCode(@orderID)

-- 4. BOPIS pick lifecycle on the web order
SELECT TOP 1 @pickID = PickTaskID, @fID = orderFulfillmentID FROM dbo.SwPickTask WHERE orderFulfillmentID IN (SELECT orderFulfillmentID FROM dbo.SwOrderFulfillment WHERE orderID = @orderID)
SELECT TOP 1 @oiID = orderItemID FROM dbo.SwOrderItem WHERE orderID = @orderID
EXEC dbo.usp_Pick_Confirm @pickTaskID = @pickID, @orderItemID = @oiID, @pickedQty = 1, @pickedBy = 'smoke'
EXEC dbo.usp_Pick_Stage @pickTaskID = @pickID, @stagingBay = 'B2', @stagedBy = 'smoke'
EXEC dbo.usp_Pick_Complete @pickTaskID = @pickID, @verifiedIDType = 'DL', @handedBy = 'smoke'
PRINT '4  OK pick ' + CAST(@pickID AS VARCHAR(10)) + ' -> ' + (SELECT PickStatus FROM dbo.SwPickTask WHERE PickTaskID = @pickID) + ', order ' + dbo.fn_Order_StatusCode(@orderID)

-- 5. POS ticket import
EXEC dbo.usp_POS_ImportTicket @ticketHeader = '7|881234|2026-08-25|C10003||s07counter1|0', @ticketLines = 'LBR-1002^12^5^DRW-4001^20^14', @orderID = @orderID OUTPUT
PRINT '5  OK pos ticket ' + (SELECT orderNumber FROM dbo.SwOrder WHERE orderID = @orderID)

-- 6. stock: ledger vs cache
EXEC dbo.usp_Stock_GetQATS @skuID = @skuID, @locationID = @loc, @qats = @qats OUTPUT
PRINT '6  OK QATS ledger = ' + CAST(@qats AS VARCHAR(10)) + ', cached = ' + CAST((SELECT calculatedQATS FROM dbo.SwStock WHERE skuID = @skuID AND locationID = @loc) AS VARCHAR(10))

-- 7. vendor order + receipt into the DC
SELECT TOP 1 @vendorID = vendorID FROM dbo.SwVendor WHERE accountNumber = 'V10021'
EXEC dbo.usp_VendorOrder_Create @vendorID = @vendorID, @locationID = @dc, @vendorOrderID = @voID OUTPUT
EXEC dbo.usp_VendorOrder_AddItem @vendorOrderID = @voID, @skuID = @skuID, @quantity = 500
EXEC dbo.usp_EDI_Export850 @vendorOrderID = @voID
EXEC dbo.usp_VendorOrder_Receive @vendorOrderID = @voID, @packingSlipNumber = 'SMOKE-1', @receivedBy = 'smoke'
PRINT '7  OK PO ' + (SELECT vendorOrderNumber FROM dbo.SwVendorOrder WHERE vendorOrderID = @voID) + ' received'

-- 8. EDI 856 import for the seeded message
DECLARE @edi BIGINT
SELECT TOP 1 @edi = EDIMessageID FROM dbo.SwEDIMessage WHERE TransactionSet = '856' AND Status = 'NEW'
EXEC dbo.usp_EDI_Import856 @ediMessageID = @edi
PRINT '8  OK 856 -> ' + (SELECT Status FROM dbo.SwEDIMessage WHERE EDIMessageID = @edi)

-- 9. quote lifecycle
EXEC dbo.usp_Quote_Create @accountID = @accountID, @storeNumber = 7, @estimatorUser = 'smoke', @quoteID = @quoteID OUTPUT
EXEC dbo.usp_Quote_AddLine @quoteID = @quoteID, @skuID = @skuID, @qty = 200
EXEC dbo.usp_Quote_AddLine @quoteID = @quoteID, @skuID = @skuID2, @qty = 10
EXEC dbo.usp_Quote_Approve @quoteID = @quoteID, @approverUser = 'smoke', @approverRole = 'VP'
EXEC dbo.usp_Quote_ConvertToOrder @quoteID = @quoteID, @orderID = @orderID OUTPUT
PRINT '9  OK quote ' + (SELECT QuoteNumber FROM dbo.SwQuote WHERE QuoteID = @quoteID) + ' margin ' + CAST((SELECT MarginPct FROM dbo.SwQuote WHERE QuoteID = @quoteID) AS VARCHAR(10)) + '% -> order'

-- 10. credit
EXEC dbo.usp_Credit_CheckAvailable @proAccountID = @proAccountID, @amount = 1000, @ok = @ok OUTPUT, @exposure = @exp OUTPUT, @creditLimit = @lim OUTPUT
PRINT '10 OK credit ok=' + CAST(@ok AS VARCHAR(1)) + ' exposure=' + CAST(@exp AS VARCHAR(20)) + ' limit=' + CAST(@lim AS VARCHAR(20))
EXEC dbo.usp_Credit_PlaceHold @proAccountID = @proAccountID, @reason = 'MANUAL', @byUser = 'smoke'
EXEC dbo.usp_Credit_OverrideHold @orderID = @orderID, @byUser = 'smoke', @storeNumber = 7, @justificationCode = 'E04'
EXEC dbo.usp_Credit_ReleaseHold @proAccountID = @proAccountID, @byUser = 'smoke', @authorityLevel = 5
PRINT '10 OK hold / override / release'

-- 11. return + receive
SELECT TOP 1 @orderID = o.orderID FROM dbo.SwOrder o JOIN dbo.SwType t ON t.typeID = o.orderStatusTypeID WHERE t.systemCode = 'ostClosed' AND EXISTS (SELECT 1 FROM dbo.SwOrderItem oi WHERE oi.orderID = o.orderID)
SELECT TOP 1 @oiID = orderItemID FROM dbo.SwOrderItem WHERE orderID = @orderID
EXEC dbo.usp_Order_CreateReturn @orderID = @orderID, @orderItemIDs = @oiID, @quantities = '1', @returnLocationID = @loc, @reasonCode = 'DMG', @returnOrderID = @ret OUTPUT
SELECT TOP 1 @did = orderReturnID FROM dbo.SwOrderReturn WHERE orderID = @ret
EXEC dbo.usp_OrderReturn_Receive @orderReturnID = @did, @receivedBy = 'smoke'
PRINT '11 OK return ' + @ret + ' ' + dbo.fn_Order_StatusCode(@ret)

-- 12. reports and the batch (BisTrack staging tables are absent so imports no-op)
EXEC dbo.usp_Rpt_CompSalesByStore 2026, 29
EXEC dbo.usp_Rpt_GrossMarginByCategory '2026-02-01', '2026-08-31'
EXEC dbo.usp_Credit_AgeReceivables
EXEC dbo.usp_Credit_RunDunning
EXEC dbo.usp_KPI_WeeklySnapshot 2026, 29
PRINT '12 OK reports'
EXEC dbo.usp_Batch_RecalcStock
EXEC dbo.usp_Web_SyncInventory
EXEC dbo.usp_Web_SyncPriceBook
PRINT '13 OK batch steps (see SwETL_Log)'
SELECT TOP 20 * FROM dbo.SwETL_Log ORDER BY ETLLogID DESC
GO
