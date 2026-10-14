<#
.Synopsis
   Gets the Shadow Data / AI dashboard from Arexdata
.DESCRIPTION
   This cmdlet returns the counters and rankings shown in the Shadow Data / AI dashboard of the connected Arexdata Server. Use "Connect-ArexServer" to connect.
   Each row has the dashboard Panel, the Rank inside that panel, the Name (application or domain\user) and the Value.
.PARAMETER DateFilter
   Date range of the dashboard. Defaults to LAST30DAYS, the same as the web dashboard.
.PARAMETER Panel
   Panels to return. Defaults to All.
.PARAMETER TagId
   Optional endpoint tag (label) id to filter by, same as the dashboard filter button.
.EXAMPLE
   Get-ArexShadowData
.EXAMPLE
   Get-ArexShadowData -DateFilter LAST7DAYS -Panel TopAIAppsUsingSensitiveData,TopUsersUsingAIAppsWithSensitiveData
.EXAMPLE
   Get-ArexShadowData | Export-Csv ShadowDataAI.csv -NoTypeInformation
#>
function Get-ArexShadowData {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory=$false,Position=0)]
		[ValidateSet('ALL','TODAY','THISWEEK','THISMONTH','THISYEAR','LAST7DAYS','LAST15DAYS','LAST30DAYS','LAST3MONTHS','LAST6MONTHS','LAST1YEAR')]
		[string] $DateFilter = 'LAST30DAYS',

		[Parameter(Mandatory=$false)]
		[ValidateSet('All','Counters','TopAIAppsHours','TopAppsUsingSensitiveData','TopAIAppsUsingSensitiveData','TopAIUsersHours','TopUsersUsingAIAppsWithSensitiveData','TopUsersUsingAppsWithSensitiveData')]
		[string[]] $Panel = 'All',

		[Parameter(Mandatory=$false)]
		[guid] $TagId
	)

	CheckConnection

	$charts = [ordered]@{
		TopAIAppsHours                       = "SensitiveScreens/charts/top-apps/ai/time-tracking/$DateFilter"
		TopAppsUsingSensitiveData            = "SensitiveScreens/charts/top-apps/non-ai/using-sensitive-data/$DateFilter"
		TopAIAppsUsingSensitiveData          = "SensitiveScreens/charts/top-apps/ai/using-sensitive-data/$DateFilter"
		TopAIUsersHours                      = "SensitiveScreens/charts/top-users/ai/time-tracking/$DateFilter"
		TopUsersUsingAIAppsWithSensitiveData = "SensitiveScreens/charts/top-users/ai/using-sensitive-data/$DateFilter"
		TopUsersUsingAppsWithSensitiveData   = "SensitiveScreens/charts/top-users/using-sensitive-data/non-ai/$DateFilter"
	}

	$filters = @(
		if ($TagId) { ArexFilter "AgentLabels" $TagId.ToString() }
	)

	$timeOffset = ArexTimeOffset

	$all = $Panel -contains 'All'

	if ($all -or $Panel -contains 'Counters') {
		$response = ArexPost "SensitiveScreens/shadowdata/reporting/$DateFilter" $filters $timeOffset

		$counters = [ordered]@{
			'AI Apps'                           = $response.aiApps
			'AI Apps using Sensitive Data'      = $response.aiAppsUsingSensitiveData
			'Apps using Sensitive Data'         = $response.appsUsingSensitiveData
			'Total rules (Shadow AI) detected'  = $response.totalRulesShadowAiDetected
		}

		foreach ($counter in $counters.GetEnumerator()) {
			[pscustomobject]@{ Panel = 'Counters'; Rank = $null; Name = $counter.Key; Value = $counter.Value }
		}
	}

	foreach ($chart in $charts.GetEnumerator()) {
		if (!$all -and $Panel -notcontains $chart.Key) { continue }

		$response = ArexPost $chart.Value $filters $timeOffset
		$rank = 0
		foreach ($item in (ArexValues $response)) {
			$rank++
			[pscustomobject]@{ Panel = $chart.Key; Rank = $rank; Name = $item.name; Value = $item.value }
		}
	}
}
