# Deploy SlatwallCommerce with Invoke-Sqlcmd (SqlServer module), in dependency order.
# Usage: .\build\deploy.ps1 -Server "localhost,1433" -User sa -Password 'Sl@tw4ll2026!' [-NoSeed]
param([string]$Server = "localhost,1433", [string]$User = "sa", [string]$Password, [switch]$NoSeed)
$here = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
function Run($file, $db) {
    Write-Host ">> $file"
    try { if ($db) { Invoke-Sqlcmd -ServerInstance $Server -Username $User -Password $Password -TrustServerCertificate -Database $db -InputFile $file -ErrorAction Stop }
          else { Invoke-Sqlcmd -ServerInstance $Server -Username $User -Password $Password -TrustServerCertificate -InputFile $file -ErrorAction Stop } }
    catch { Write-Warning "FAILED: $file :: $($_.Exception.Message)" }
}
Run "$here\sql\00_create_database.sql" $null
Get-ChildItem "$here\sql\01_schema" -Recurse -Filter *.sql | Where-Object { $_.DirectoryName -notlike "*_constraints*" } | ForEach-Object { Run $_.FullName "SlatwallCommerce" }
Get-ChildItem "$here\sql\01_schema\_constraints" -Filter *.sql | ForEach-Object { Run $_.FullName "SlatwallCommerce" }
Get-ChildItem "$here\sql\02_reference_data" -Filter *.sql | Sort-Object Name | ForEach-Object { Run $_.FullName "SlatwallCommerce" }
Run "$here\sql\05_views\vw_NewID.sql" "SlatwallCommerce"
1..3 | ForEach-Object { Get-ChildItem "$here\sql\04_functions" -Filter *.sql | ForEach-Object { Run $_.FullName "SlatwallCommerce" } }   # functions reference each other
1..2 | ForEach-Object { Get-ChildItem "$here\sql\03_procs" -Recurse -Filter *.sql | ForEach-Object { Run $_.FullName "SlatwallCommerce" } }
Get-ChildItem "$here\sql\05_views" -Filter *.sql | ForEach-Object { Run $_.FullName "SlatwallCommerce" }
Get-ChildItem "$here\sql\06_triggers" -Filter *.sql | ForEach-Object { Run $_.FullName "SlatwallCommerce" }
if (-not $NoSeed) { Get-ChildItem "$here\sql\07_seed" -Filter *.sql | Sort-Object Name | ForEach-Object { Run $_.FullName "SlatwallCommerce" } }
Write-Host "Deploy complete. Expected failure: usp_ShipFromStore_Evaluate (see docs\expected_failures.md)."
