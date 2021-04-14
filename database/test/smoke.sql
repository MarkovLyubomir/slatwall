-- smoke test placeholder (2021): run usp_Order_PlaceOrder against a test order and compare totals
SELECT TOP 10 orderNumber, calculatedTotal FROM dbo.SwOrder ORDER BY orderOpenDateTime DESC
