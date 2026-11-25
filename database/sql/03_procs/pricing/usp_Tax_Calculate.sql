/* =============================================================================
   Procedure: dbo.usp_Tax_Calculate
   Author:    Wade Hollister
   Created:   2014-06-12
   Purpose:   Sales tax per line. Rate from SwTaxCategoryRate by the order's
              ship/pickup state; falls back to a setting 'defaultTaxRate'.
              Tax-exempt accounts get zero. No Avalara - rates are maintained
              by hand in the admin.
   Change log:
     2014-06-12  WH   Initial version
     2016-11-07  WH   County rates via SwLocationZone.TaxJurisdiction
     2023-01-09  WH   Pro accounts with a resale certificate attribute are exempt
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Tax_Calculate', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Tax_Calculate
GO
CREATE PROCEDURE dbo.usp_Tax_Calculate
    @orderID CHAR(32)
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @accountID CHAR(32), @exempt BIT, @state CHAR(2), @rate FLOAT, @locationID CHAR(32), @jur VARCHAR(20), @rateID CHAR(32)
    SELECT @accountID = o.accountID, @locationID = o.locationID, @exempt = a.taxExemptFlag, @state = ad.stateCode
    FROM dbo.SwOrder o LEFT JOIN dbo.SwAccount a ON a.accountID = o.accountID LEFT JOIN dbo.SwAddress ad ON ad.addressID = o.shippingAddressID
    WHERE o.orderID = @orderID

    DELETE dbo.SwTaxApplied WHERE orderItemID IN (SELECT orderItemID FROM dbo.SwOrderItem WHERE orderID = @orderID)

    IF @exempt = 1 RETURN
    IF EXISTS (SELECT 1 FROM dbo.SwAttributeValue av JOIN dbo.SwAttribute a ON a.attributeID = av.attributeID WHERE av.accountID = @accountID AND a.attributeCode = 'resaleCertNo' AND LEN(av.attributeValue) > 0) RETURN

    IF @state IS NULL SELECT @state = StateCode FROM dbo.SwStoreProfile WHERE locationID = @locationID
    SELECT TOP 1 @jur = TaxJurisdiction FROM dbo.SwLocationZone WHERE locationID = @locationID AND EndDate IS NULL ORDER BY EffectiveDate DESC

    SELECT TOP 1 @rate = r.taxRate, @rateID = r.taxCategoryRateID
    FROM dbo.SwTaxCategoryRate r JOIN dbo.SwTaxCategory c ON c.taxCategoryID = r.taxCategoryID
    WHERE c.taxCategoryCode = 'STANDARD' AND r.taxCategoryRateCode = ISNULL(@jur, @state)
    IF @rate IS NULL SELECT TOP 1 @rate = r.taxRate, @rateID = r.taxCategoryRateID FROM dbo.SwTaxCategoryRate r JOIN dbo.SwTaxCategory c ON c.taxCategoryID = r.taxCategoryID WHERE c.taxCategoryCode = 'STANDARD' AND r.taxCategoryRateCode = @state
    IF @rate IS NULL SET @rate = TRY_CAST(dbo.fn_SettingValue('defaultTaxRate') AS FLOAT)
    IF @rate IS NULL SET @rate = 6.75   -- NC state + typical county, 2014

    INSERT dbo.SwTaxApplied (taxAppliedID, taxAmount, taxRate, appliedType, currencyCode, taxStateCode, taxJurisdictionName, taxCategoryRateID, orderItemID, createdDateTime)
    SELECT dbo.fn_NewID32(), ROUND(oi.price * oi.quantity * @rate / 100.0, 2), @rate, 'orderItem', 'USD', @state, @jur, @rateID, oi.orderItemID, GETDATE()
    FROM dbo.SwOrderItem oi WHERE oi.orderID = @orderID AND oi.orderItemTypeID = dbo.fn_GetTypeID('orderItemType','oitSale')
END
GO
