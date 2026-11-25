/* =============================================================================
   Procedure: dbo.usp_Pro_RetierAccounts
   Author:    Wade Hollister
   Created:   2016-02-01
   Purpose:   Annual re-tiering (1 Feb). Thresholds from SAL-106 §3.1 hard-coded.
              Tier 1 >= $750k TTM, Tier 2 >= $300k, Tier 3 >= $100k, Tier 4 >= $25k, else 5.
              Rep can "protect" an account from demotion via SwSetting 'tierProtect:<BTCustomerNo>'.
   Change log:
     2016-02-01  WH   Initial version (3 tiers)
     2024-02-05  WH   Five tiers, thresholds re-based on TTM
     2026-02-02  WH   Protect list moved from a CSV on the share to SwSetting
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Pro_RetierAccounts', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Pro_RetierAccounts
GO
CREATE PROCEDURE dbo.usp_Pro_RetierAccounts
    @dryRun BIT = 1
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @proAccountID INT, @accountID CHAR(32), @ttm DECIMAL(19,2), @old TINYINT, @new TINYINT, @bt VARCHAR(20), @changed INT = 0
    EXEC dbo.usp_Pro_CalcTTMPurchases

    DECLARE c CURSOR LOCAL FOR SELECT ProAccountID, accountID, TTMPurchases, Tier, BTCustomerNo FROM dbo.SwProAccount WHERE ActiveFlag = 1
    OPEN c
    FETCH NEXT FROM c INTO @proAccountID, @accountID, @ttm, @old, @bt
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @new = CASE WHEN @ttm >= 750000 THEN 1 WHEN @ttm >= 300000 THEN 2 WHEN @ttm >= 100000 THEN 3 WHEN @ttm >= 25000 THEN 4 ELSE 5 END
        IF @new > @old AND dbo.fn_SettingValue('tierProtect:' + ISNULL(@bt, '')) = '1' SET @new = @old   -- protected from demotion
        IF @new <> @old
        BEGIN
            SET @changed = @changed + 1
            IF @dryRun = 0
            BEGIN
                UPDATE dbo.SwProAccount SET Tier = @new, TierEffectiveDate = CAST(GETDATE() AS DATE), UpdatedOn = GETDATE(), UpdatedBy = 'retier' WHERE ProAccountID = @proAccountID
                DELETE apg FROM dbo.SwAccountPriceGroup apg JOIN dbo.SwPriceGroup pg ON pg.priceGroupID = apg.priceGroupID WHERE apg.accountID = @accountID AND pg.priceGroupCode LIKE 'PRO-T%'
                INSERT dbo.SwAccountPriceGroup (accountID, priceGroupID) SELECT @accountID, priceGroupID FROM dbo.SwPriceGroup WHERE priceGroupCode = 'PRO-T' + CAST(@new AS VARCHAR(1))
                EXEC dbo.usp_Price_ApplyProTier @accountID
                INSERT dbo.SwWebSync_Product (skuID, Action, Payload) VALUES ('CUSTGROUP', 'CUSTGRP', @accountID + '|PRO' + CAST(@new AS VARCHAR(1)))   -- abuses the product sync table
            END
            ELSE
                PRINT 'Would move ' + ISNULL(@bt, @accountID) + ' from tier ' + CAST(@old AS VARCHAR(1)) + ' to ' + CAST(@new AS VARCHAR(1))
        END
        FETCH NEXT FROM c INTO @proAccountID, @accountID, @ttm, @old, @bt
    END
    CLOSE c DEALLOCATE c
    INSERT dbo.SwETL_Log (JobName, StepName, RowsAffected, Status, Message, FinishedOn) VALUES ('usp_Pro_RetierAccounts', CASE @dryRun WHEN 1 THEN 'dryrun' ELSE 'apply' END, @changed, 'OK', NULL, GETDATE())
END
GO
