# SlatwallCommerce database

**System:** SlatwallCommerce (SWC) — commerce and omnichannel transactional datastore for slatwall.com, the store counter order path, pro-desk quoting and BOPIS/delivery fulfilment at Slatwall Building Supply Co.
**Platform:** Microsoft SQL Server (on-premises, GSO-SQL01, Greensboro; DR copy to Azure). Compatibility level 130 (raised from 110 in 2021 for OPENJSON).
**Owner:** IT Applications (W. Hollister, P. Nance). Tier 1 in the TEC-006 application portfolio; disposition *Migrate* (order path to Manhattan Active OM under Project Keystone; financial posting stays in Epicor BisTrack).
**Origin:** Stood up in March 2014 by Epicor Professional Services as the persistence layer of a Slatwall (open-source CFML commerce platform) deployment that fronted BisTrack for the first web store. The ORM-generated `Sw*` tables are still the core; everything after 2014 was added by the two in-house developers directly in T-SQL as stored procedures, extension tables (`Sw*` with INT identity keys) and the three Access databases that were imported in 2023 (`tbl*`).

This folder is the deployable definition of the database as of August 2026: schema, reference data, stored procedures, functions, views, triggers and a small sample data set.

## Layout

```
database/
  sql/00_create_database.sql       database + options
  sql/01_schema/<domain>/           one CREATE TABLE per file (186 tables)
  sql/01_schema/_constraints/       foreign keys per domain (added WITH NOCHECK in 2017)
  sql/02_reference_data/            SwType hierarchy, stores, zones, fiscal calendar, settings
  sql/03_procs/<domain>/            stored procedures, one per file (148)
  sql/04_functions/                 scalar / table functions (19, incl. the CLR bridge stub)
  sql/05_views/                     views incl. the vw_BT_* feeds read by external systems (12)
  sql/06_triggers/                  triggers (6, one disabled)
  sql/07_seed/                      sample data (products, accounts, orders, stock)
  build/deploy.sh | deploy.ps1      ordered deploy with sqlcmd / Invoke-Sqlcmd
  test/smoke.sql                    end-to-end smoke test
  docs/                             customization register, interface register, expected failures
```

Domains: `platform`, `stores`, `catalog`, `pricing`, `credit` (customers, pro accounts, AR), `orders`, `fulfillment` (BOPIS, will-call, delivery), `inventory`, `vendors`, `integration`, `reporting`.

## Deploying locally

```
docker run -e ACCEPT_EULA=Y -e MSSQL_SA_PASSWORD='Sl@tw4ll2026!' -p 1433:1433 -d --name swc mcr.microsoft.com/mssql/server:2022-latest
build/deploy.sh localhost,1433 sa 'Sl@tw4ll2026!'
sqlcmd -S localhost,1433 -U sa -P 'Sl@tw4ll2026!' -C -i test/smoke.sql
```

One object is known not to compile (`usp_ShipFromStore_Evaluate`); see `docs/expected_failures.md`. Procedures that read BisTrack staging tables (`##BT_*`) no-op or raise when the SSIS packages have not run — the smoke test avoids them.

## Where things are

| Need | Start at |
|---|---|
| Place an order (any channel) | `usp_Order_PlaceOrder`; channel entry points `usp_Web_ImportOrder`, `usp_POS_ImportTicket`, `usp_Order_Create` |
| Sell price | `usp_Price_GetSellPrice` (counter), `usp_Web_GetPrice` (web), `usp_Quote_PriceLine` (quotes) |
| Stock position | `fn_Stock_QOH` / `fn_Stock_QATS` (ledger), `SwStock.calculated*` (cache refreshed by `usp_Batch_RecalcStock`) |
| Pro credit | `usp_Credit_CheckAvailable`, `usp_Credit_PlaceHold`, `usp_Credit_ReleaseHold`, `usp_Credit_OverrideHold` |
| BOPIS | `usp_Pick_CreateTask` → `usp_Pick_Confirm` → `usp_Pick_Stage` → `usp_Pick_Complete`; `usp_BOPIS_AbandonAfter72h` |
| Nightly batch | `usp_Batch_Nightly` (SQL Agent "SWC - Nightly", 22:30) |
| External feeds | `vw_BT_Orders`, `vw_BT_OrderLines`, `vw_BT_Inventory`, `vw_BT_Customers`, `vw_BT_ARAging`, `SwIntegrationQueue` |

---
*FICTIONAL SAMPLE — created solely to demonstrate the 3Pillar Helix Atlas platform. Slatwall Building Supply Co. does not exist; the people named are invented. The schema is derived from the open-source Slatwall commerce platform (github.com/ten24/Slatwall, GPL) for structural realism only. Real product names are used for realism; no affiliation or endorsement is implied.*
