<#
.Synopsis
   Gets the AI interactions from Arexdata
.DESCRIPTION
   This cmdlet returns the AI prompts with sensitive data detected by the connected Arexdata Server: user, AI app, matched rules and a summary of the prompt. Use "Connect-ArexServer" to connect.
.PARAMETER Source
   Where the interactions come from: Endpoint (browser and desktop AI apps), Copilot (Microsoft 365), Gateway (AI Gateway) or All. Defaults to All.
.PARAMETER DateFilter
   Date range of the interactions. Defaults to LAST7DAYS, the same as the web report.
.PARAMETER First
   Maximum number of interactions to return. Defaults to 100; 0 returns all of them.
.EXAMPLE
   Get-ArexAiInteractions
.EXAMPLE
   Get-ArexAiInteractions -Source Copilot -DateFilter LAST30DAYS | Format-List
#>
function Get-ArexAiInteractions {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory=$false,Position=0)]
		[ValidateSet('All','Endpoint','Copilot','Gateway')]
		[string] $Source = 'All',

		[Parameter(Mandatory=$false)]
		[ValidateSet('ALL','TODAY','THISWEEK','THISMONTH','THISYEAR','LAST7DAYS','LAST15DAYS','LAST30DAYS','LAST3MONTHS','LAST6MONTHS','LAST1YEAR')]
		[string] $DateFilter = 'LAST7DAYS',

		[Parameter(Mandatory=$false)]
		[int] $First = 100
	)

	CheckConnection

	$api = switch ($Source) {
		'All'      { "AiInteractions/{skip}/{take}" }
		'Endpoint' { "AiInteractions/endpoint/{skip}/{take}" }
		'Copilot'  { "AiInteractions/copilot/{skip}/{take}" }
		'Gateway'  { "AiInteractions/gateway/{skip}/{take}" }
	}

	$filters = @(
		if ($DateFilter -ne 'ALL') { ArexFilter "Date" $DateFilter -dateFilter "Relative" }
	)

	ArexPostList $api $filters $First | ForEach-Object {
		[pscustomobject]@{
			date       = $_.date
			user       = $_.user
			chatOrigin = $_.chatOrigin
			serverName = $_.serverName
			policy     = $_.policy.name
			rules      = $_.rules
			prompt     = $_.prompt.resume
		}
	}
}
