<#
.Synopsis
   Guided demo of the Arexdata API through Arexdata PowerCLI
.DESCRIPTION
   Connects to an Arexdata Server and walks through the main Get-Arex* cmdlets: server version, endpoints, alerts,
   AI interactions, Shadow Data / AI, sensitive files and file events. It pauses between steps unless -NoPause is used,
   and can export every step to CSV with -OutputFolder.
.PARAMETER Server
   Arexdata API server, e.g. api.eu.arexdata.com
.PARAMETER Credential
   Arexdata user (email) and password. Prompted when not given.
.PARAMETER DateFilter
   Date range used by every step. Defaults to LAST30DAYS.
.PARAMETER Top
   Rows shown per step. Defaults to 10.
.PARAMETER OutputFolder
   Folder where each step is also exported as CSV.
.PARAMETER NoPause
   Run every step without waiting for a key.
.EXAMPLE
   .\Scripts\Demo-ArexApi.ps1 -Server api.dev.eu.arexdata.com
.EXAMPLE
   .\Scripts\Demo-ArexApi.ps1 -Server api.dev.eu.arexdata.com -DateFilter LAST7DAYS -OutputFolder C:\temp\arexdemo -NoPause
#>
param (
	[Parameter(Mandatory=$true)]
	[string] $Server,
	[System.Management.Automation.CredentialAttribute()] $Credential,
	[ValidateSet('ALL','TODAY','THISWEEK','THISMONTH','THISYEAR','LAST7DAYS','LAST15DAYS','LAST30DAYS','LAST3MONTHS','LAST6MONTHS','LAST1YEAR')]
	[string] $DateFilter = 'LAST30DAYS',
	[int] $Top = 10,
	[string] $OutputFolder,
	[switch] $NoPause
)

Import-Module "$PSScriptRoot\..\Arexdata.psd1" -Force -WarningAction SilentlyContinue

if (!$Credential) { $Credential = Get-Credential -Message "Arexdata user (email) and password" }
if ($OutputFolder) { New-Item -ItemType Directory -Force -Path $OutputFolder | Out-Null }

function Step {
	param ([string] $title, [string] $command, [scriptblock] $action, [string] $csv)

	Write-Host ""
	Write-Host "[*] $title" -ForegroundColor Cyan
	Write-Host "    PS> $command" -ForegroundColor DarkGray

	try {
		$result = @(& $action)
		$result | Select-Object -First $Top | Format-Table -AutoSize | Out-String -Width 200 | Write-Host
		Write-Host "    $($result.Count) row(s)" -ForegroundColor DarkGray
		if ($OutputFolder -and $csv -and $result.Count) {
			$result | Export-Csv (Join-Path $OutputFolder $csv) -NoTypeInformation
		}
	} catch {
		Write-Host "    Error: $($_.Exception.Message)" -ForegroundColor Red
	}

	if (!$NoPause) { Read-Host "    Press Enter to continue" | Out-Null }
}

Write-Host ""
Write-Host "-------------------------------------------------" -ForegroundColor Cyan
Write-Host " Arexdata API demo - $Server ($DateFilter)" -ForegroundColor Cyan
Write-Host "-------------------------------------------------" -ForegroundColor Cyan

Connect-ArexServer -Server $Server -Credential $Credential | Out-Null

Step "Server version" "Get-ArexVersion" { Get-ArexVersion }

Step "Endpoints with the Arexdata agent" "Get-ArexEndpoints" { Get-ArexEndpoints } "Endpoints.csv"

Step "Triggered alerts" "Get-ArexAlerts -DateFilter $DateFilter" { Get-ArexAlerts -DateFilter $DateFilter } "Alerts.csv"

Step "AI prompts with sensitive data" "Get-ArexAiInteractions -DateFilter $DateFilter" { Get-ArexAiInteractions -DateFilter $DateFilter } "AiInteractions.csv"

Step "Shadow Data / AI dashboard" "Get-ArexShadowData -DateFilter $DateFilter" { Get-ArexShadowData -DateFilter $DateFilter } "ShadowDataAI.csv"

Step "Files with sensitive data" "Get-ArexSensitiveFiles -DateFilter $DateFilter" { Get-ArexSensitiveFiles -DateFilter $DateFilter } "SensitiveFiles.csv"

Step "Most active users on files" "Get-ArexFileEvents -DateFilter $DateFilter -First 1000 | Group-Object domainAndUser" {
	Get-ArexFileEvents -DateFilter $DateFilter -First 1000 |
		Group-Object domainAndUser | Sort-Object Count -Descending |
		Select-Object @{ n = 'user'; e = { $_.Name } }, @{ n = 'events'; e = { $_.Count } }
} "TopFileUsers.csv"

Write-Host ""
Write-Host "[*] Demo finished." -ForegroundColor Green
if ($OutputFolder) { Write-Host "    CSV files in $OutputFolder" -ForegroundColor Green }
