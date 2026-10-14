<#
.Synopsis
   Gets the triggered alerts from Arexdata
.DESCRIPTION
   This cmdlet returns the alert records triggered in the connected Arexdata Server, newest first. Use "Connect-ArexServer" to connect.
   The id of each record is the RecordId used by Get-ArexAlertDetail and Get-ArexAlertSumary.
.PARAMETER DateFilter
   Date range of the alerts. Defaults to LAST7DAYS, the same as the web report.
.PARAMETER First
   Maximum number of alerts to return. Defaults to 100; 0 returns all of them.
.EXAMPLE
   Get-ArexAlerts
.EXAMPLE
   Get-ArexAlerts -DateFilter LAST30DAYS -First 0 | Group-Object severityTypeName
#>
function Get-ArexAlerts {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory=$false,Position=0)]
		[ValidateSet('ALL','TODAY','THISWEEK','THISMONTH','THISYEAR','LAST7DAYS','LAST15DAYS','LAST30DAYS','LAST3MONTHS','LAST6MONTHS','LAST1YEAR')]
		[string] $DateFilter = 'LAST7DAYS',

		[Parameter(Mandatory=$false)]
		[int] $First = 100
	)

	CheckConnection

	$filters = @(
		if ($DateFilter -ne 'ALL') { ArexFilter "ReportedAt" $DateFilter -dateFilter "Relative" -sort "Descending" }
	)

	$obj = ArexPostList "ServerAlert/Records/{skip}/{take}" $filters $First

	$prop = @(
		'reportedAt',
		'serverAlertName',
		'typeName',
		'severityTypeName',
		'objectName',
		'compliantAmount',
		'id'
	)

	FormatArexResult $obj $prop
}
