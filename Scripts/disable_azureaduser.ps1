param (
	[string] $source,
    [string] $alertname,
    [string] $severity,
    [string] $alertype,
    [string] $alertid,
    [string] $alertrecordid = "ce6ff581-c5f2-4527-86da-efd2c378f5f3",
    [string] $initat,
    [string] $endat
)

#-- CONST ----
$AREXSERVER= "api.eu.arexdata.com"
$AREXUSER = "user"
$AREXPASS = "password"
$ADUSER = "365user"
$ADPASS = "password"
#-------------

Start-Transcript -path $($PSCommandPath + ".txt") -append

write-host "---------------------------------------"
write-host "Arexdata alert powershell script sample"
write-host "---------------------------------------"

write-host "params: | $source | $alertname | $severity | $alertype | $alertid | $alertrecordid | $initat | $endat |"

$password = ConvertTo-SecureString $ADPASS -AsPlainText -Force
$psCred = New-Object System.Management.Automation.PSCredential -ArgumentList ($ADUSER, $password)

Write-host "Connecting Arexdata..."
Import-Module arexdata   | Out-Null
Connect-ArexServer -Server $AREXSERVER -User $AREXUSER -Password $AREXPASS  | Out-Null
$alert = Get-ArexAlertDetail -RecordId $alertrecordid

$users = $alert | Group-Object -Property user

Write-Host "Connecting AzureAD..."
Connect-AzureAD -Credential $psCred

foreach($u in $users){
	Write-Host "Disabling user: " $u.Name
    Set-AzureADUser -ObjectID $u.Name -AccountEnabled $false
}

Stop-Transcript

