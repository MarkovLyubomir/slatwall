# Known deployment and runtime failures

These are real defects in the SlatwallCommerce codebase that the deploy scripts tolerate. They are listed here so a clean deploy can be told apart from a broken one.

| Object | Symptom | Since | Notes |
|---|---|---|---|
| `usp_ShipFromStore_Evaluate` | `CREATE PROCEDURE` fails: *Invalid column name 'DistanceMiles'* | 2020-05-11 | Half-built during the 2020 web surge; the call in `usp_Order_PlaceOrder` is commented out. The deploy script prints `!! FAILED` for this file and continues. |
| `usp_Price_ImportZonePrices`, `usp_Billtrust_ImportPayments`, `usp_Account_SyncFromBisTrack`, `usp_Catalog_ImportFromBisTrack`, `usp_Stock_ReconcileToBisTrack` | Raise or no-op when the SSIS staging tables (`##BT_ZonePrice`, `##BilltrustPayments`, `##BT_Customer`, `##BT_Item`, `##BT_OnHand`) are absent | — | Staging is created by the BisTrack SSIS packages, not by this repository. `usp_Batch_Nightly` therefore fails at step 03 on a standalone deploy. |
| `usp_Rebate_Accrue`, `usp_Credit_LogException` (fallback path) | Linked server `[ACCESS_REBATES]` / `[ACCESS_CREDIT]` does not exist | 2024 | Both fall back to the local `tbl*` copies; `usp_Credit_LogException` only hits the linked server if the local insert fails. |
| `usp_Lien_GenerateNTO`, `usp_Billtrust_ExportInvoices` | `xp_cmdshell` disabled / file share unreachable | — | Both need `xp_cmdshell` enabled and the Greensboro file shares. |
| `usp_Batch_Nightly`, `usp_Stock_ReconcileToBisTrack` | `msdb.dbo.sp_send_dbmail` profile `SWC` missing | — | Database Mail is configured on GSO-SQL01 only. |
| `usp_OrderPayment_RunPlaceOrderTransaction` | Uses `clr_AdyenAuthorize` | 2018 | In production this is an UNSAFE CLR assembly (SlatwallPayBridge.dll); this repository ships a T-SQL stub (`sql/04_functions/clr_AdyenAuthorize.sql`) that always approves. |
| `usp_Stock_ReleaseExpiredHolds` | Only scheduled Mon–Fri | 2019 | Weekend BOPIS holds expire two days late. Not a deploy failure; documented because it is reported as a bug every spring. |
| `SwPromotionApplied` | Has both `orderfulfillmentID` and `orderFulfillmentID` in the ORM mapping | 2014 | Collapsed to one column in SQL Server (case-insensitive collation); the CF entity still declares both. |

*FICTIONAL SAMPLE — 3Pillar Atlas demo.*
