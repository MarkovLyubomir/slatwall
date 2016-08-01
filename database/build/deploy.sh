#!/usr/bin/env bash
# Deploy SlatwallCommerce to a SQL Server instance with sqlcmd, in dependency order.
# Usage: build/deploy.sh <server> <user> <password> [--no-seed]
# Example (local Docker):
#   docker run -e ACCEPT_EULA=Y -e MSSQL_SA_PASSWORD='Sl@tw4ll2026!' -p 1433:1433 -d --name swc mcr.microsoft.com/mssql/server:2022-latest
#   build/deploy.sh localhost,1433 sa 'Sl@tw4ll2026!'
set -u
SERVER="${1:-localhost,1433}"; USER="${2:-sa}"; PASS="${3:-}"; NOSEED="${4:-}"
HERE="$(cd "$(dirname "$0")/.." && pwd)"
SQLCMD="${SQLCMD:-sqlcmd}"
run() { echo ">> $1"; "$SQLCMD" -S "$SERVER" -U "$USER" -P "$PASS" -C -b -i "$1" || echo "!! FAILED: $1"; }
run_db() { echo ">> $1"; "$SQLCMD" -S "$SERVER" -U "$USER" -P "$PASS" -C -d SlatwallCommerce -i "$1" || echo "!! FAILED: $1"; }
run "$HERE/sql/00_create_database.sql"
for f in "$HERE"/sql/01_schema/*/*.sql; do case "$f" in */_constraints/*) ;; *) run_db "$f";; esac; done
for f in "$HERE"/sql/01_schema/_constraints/*.sql; do run_db "$f"; done
for f in "$HERE"/sql/02_reference_data/*.sql; do run_db "$f"; done
run_db "$HERE/sql/05_views/vw_NewID.sql"                                  # fn_NewID32 depends on it
for pass in 1 2 3; do for f in "$HERE"/sql/04_functions/*.sql; do          # functions reference each other; 3 passes resolve the order
  if [ $pass -eq 3 ]; then run_db "$f"; else run_db "$f" > /dev/null 2>&1; fi; done; done
for pass in 1 2; do for f in "$HERE"/sql/03_procs/*/*.sql; do             # procs: pass 1 quiet, pass 2 reports what still fails
  if [ $pass -eq 2 ]; then run_db "$f"; else run_db "$f" > /dev/null 2>&1; fi; done; done
for f in "$HERE"/sql/05_views/*.sql; do run_db "$f"; done
for f in "$HERE"/sql/06_triggers/*.sql; do run_db "$f"; done
if [ "$NOSEED" != "--no-seed" ]; then for f in "$HERE"/sql/07_seed/*.sql; do run_db "$f"; done; fi
echo "Deploy complete. Expected failure: usp_ShipFromStore_Evaluate (see docs/expected_failures.md)."
