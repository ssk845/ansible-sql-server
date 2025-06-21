param (
  [string]$SqlInstance
)

Import-Module dbatools
Set-DbatoolsInsecureConnection -SessionOnly

if (-not (Get-DbaDatabase -SqlInstance $SqlInstance -Database "DBAdmin" -ErrorAction SilentlyContinue)) {
    New-DbaDatabase -SqlInstance $SqlInstance -Name "DBAdmin"
}
Set-DbatoolsInsecureConnection -SessionOnly
Install-DbaFirstResponderKit -SqlInstance $SqlInstance -Database "DBAdmin"
Install-DbaMaintenanceSolution -SqlInstance $SqlInstance -Database "DBAdmin"