<#
.Synopsis
   Gets the file events from Arexdata
.DESCRIPTION
   This cmdlet returns the file activity (who did what to which file, and when) audited by the connected Arexdata Server across all servers, newest first. Use "Connect-ArexServer" to connect.
.PARAMETER DateFilter
   Date range of the events. Defaults to LAST7DAYS, the same as the web report.
.PARAMETER First
   Maximum number of events to return. Defaults to 100; 0 returns all of them.
.EXAMPLE
   Get-ArexFileEvents
.EXAMPLE
   Get-ArexFileEvents -DateFilter TODAY -First 1000 | Group-Object domainAndUser | Sort-Object Count -Descending
#>
function Get-ArexFileEvents {
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
		if ($DateFilter -ne 'ALL') { ArexFilter "Date" $DateFilter -dateFilter "Relative" -sort "Descending" }
	)

	$obj = ArexPostList "FileEvents/allservers/{skip}/{take}" $filters $First

	$prop = @(
		'date',
		'server',
		'source',
		'domainAndUser',
		'operationName',
		'filePath'
	)

	FormatArexResult $obj $prop
}
