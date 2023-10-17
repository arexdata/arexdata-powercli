Start-Transcript -path c:\arexdata\scripts\fs_alert_output.txt -append

param (
	[string] $source,
    [string] $alertname,
    [string] $severity,
    [string] $alertype,
    [string] $alertid,
    [string] $recordid,
    [string] $initat,
    [string] $endat
)

write-host "---------------------------------------"
write-host "Arexdata alert powershell script sample"
write-host "---------------------------------------"

Import-Module arexdata
Connect-ArexServer -Server api.dev.eu.arexdata.com -User admin@lab.local -Password password
$alert = Get-ArexAlertDetail -RecordId bb4aef1e-3418-4142-afcc-b777d0af5be4
$alert|Select-Object -Property user, operationname


Stop-Transcript

