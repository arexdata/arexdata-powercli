<#
.Synopsis
   Gets Alerts from Arexdata
.DESCRIPTION
   This cmdlet returns the alerts from the connected Arexdata Server. Use "Connect-ArexServer" to connect.
.EXAMPLE
   Get-ArexAlert -RecordId xxxx-xxx-xxxx
#>
function Get-ArexAlert {
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
