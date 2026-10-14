

<#
.Synopsis
   Gets the users involved in a file event alert from Arexdata
.DESCRIPTION
   This cmdlet returns, for one triggered file event alert, the top 20 users and how many file events each one generated. Use "Connect-ArexServer" to connect.
   Each row has item1 (domain\user) and item2 (number of events). Use Get-ArexAlertDetail to see the events themselves.
.PARAMETER RecordId
   Id of the triggered alert record, as returned in the id column of Get-ArexAlerts.
.EXAMPLE
   Get-ArexAlertSumary -RecordId bb4aef1e-3418-4142-afcc-b777d0af5be4
.EXAMPLE
   Get-ArexAlerts | Where-Object typeName -eq 'FileEvents' | Select-Object -First 1 | ForEach-Object { Get-ArexAlertSumary -RecordId $_.id }
#>
function Get-ArexAlertSumary {
	[CmdletBinding()]
	param(
        [Parameter(Mandatory=$true,Position=0)]
		[string] $RecordId
    )

	CheckConnection
	$response = ArexGet("FileEvents/ServerAlert/groupbyuser/$RecordId/20")
	$obj = $response.{$values}

	$prop = @('item1','item2')

	FormatArexResult $obj $prop 
}
