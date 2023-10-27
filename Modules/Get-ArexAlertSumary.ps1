

<#
.Synopsis
   Gets Alerts from Arexdata
.DESCRIPTION
   This cmdlet returns the alerts from the connected Arexdata Server. Use "Connect-ArexServer" to connect.
.EXAMPLE
   Get-ArexAlertSumary -RecordId xxxx-xxx-xxxx
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
