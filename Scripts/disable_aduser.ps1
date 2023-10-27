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
$AREXUSER = "admin@company.local"
$AREXPASS = "password"
$DCHOST = "dc01"
$DCUSER = "lab\admin"
$DCPASS = "password"
#-------------

Start-Transcript -path c:\arexdata\scripts\action_output.txt -append
Set-ExecutionPolicy Unrestricted

write-host "---------------------------------------"
write-host "Arexdata alert powershell script sample"
write-host "---------------------------------------"

write-host "params: | $source | $alertname | $severity | $alertype | $alertid | $alertrecordid | $initat | $endat |"

Write-Host "Connecting AD..."
Import-Module -Name ActiveDirectory

$password = ConvertTo-SecureString $DCPASS -AsPlainText -Force
$psCred = New-Object System.Management.Automation.PSCredential -ArgumentList ($DCUSER, $password)

Write-host "Connecting Arexdata..."
Import-Module arexdata   | Out-Null
Connect-ArexServer -Server api.dev.eu.arexdata.com -User $AREXUSER -Password $AREXPASS  | Out-Null
$alert = Get-ArexAlertDetail -RecordId $alertrecordid

$users = $alert | Group-Object -Property user

foreach($u in $users){
	Write-Host "Disabling user: " $u.Name
	Invoke-Command -ComputerName $DCHOST -Credential $psCred -ArgumentList $u.Name -ScriptBlock { 
		param ($user) 
		Get-ADUser -Identity $user 
		Disable-ADAccount -Identity $user
        Get-ADUser -Identity $user 
	}
}


Stop-Transcript

