<#
.Synopsis
   Gets the files with sensitive data from Arexdata
.DESCRIPTION
   This cmdlet returns the files where the connected Arexdata Server detected sensitive data, newest detection first. Use "Connect-ArexServer" to connect.
.PARAMETER DateFilter
   Detection date range. Defaults to LAST7DAYS, the same as the web report.
.PARAMETER First
   Maximum number of files to return. Defaults to 100; 0 returns all of them.
.EXAMPLE
   Get-ArexSensitiveFiles
.EXAMPLE
   Get-ArexSensitiveFiles -DateFilter LAST30DAYS -First 0 | Export-Csv SensitiveFiles.csv -NoTypeInformation
#>
function Get-ArexSensitiveFiles {
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
		if ($DateFilter -ne 'ALL') { ArexFilter "DetectionDate" $DateFilter -dateFilter "Relative" -sort "Descending" }
	)

	$obj = ArexPostList "FoldersFiles/SensitiveFiles/{skip}/{take}/false" $filters $First

	$prop = @(
		'detectionDate',
		'serverName',
		'fullPath',
		'ownerDomainAndUser',
		'rulesInString',
		'totalSensitive'
	)

	FormatArexResult $obj $prop
}
