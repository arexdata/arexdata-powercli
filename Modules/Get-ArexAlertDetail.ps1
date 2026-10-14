<#
.Synopsis
   Gets the file events that triggered an alert from Arexdata
.DESCRIPTION
   This cmdlet returns the first 100 file events (date, server, user, operation and file) behind one triggered file event alert of the connected Arexdata Server. Use "Connect-ArexServer" to connect.
.PARAMETER RecordId
   Id of the triggered alert record, as returned in the id column of Get-ArexAlerts.
.EXAMPLE
   Get-ArexAlertDetail -RecordId bb4aef1e-3418-4142-afcc-b777d0af5be4
.EXAMPLE
   Get-ArexAlertDetail -RecordId bb4aef1e-3418-4142-afcc-b777d0af5be4 | Select-Object -Property user, operationName
#>
function Get-ArexAlertDetail {
	[CmdletBinding()]
	param(
        [Parameter(Mandatory=$true,Position=0)]
		[string] $RecordId
    )

	CheckConnection
	$response = ArexPost("FileEvents/ServerAlert/$RecordId/0/100")
    #$response.listdata.{$values}

	$obj = $response.listdata.{$values}

	$prop = @('date','server', 'source', 'operationName', 'userDomain', 'user','filepath','filename')

	FormatArexResult $obj $prop 
}
