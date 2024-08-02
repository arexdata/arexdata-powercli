

<#
.Synopsis
   Gets Alerts from Arexdata
.DESCRIPTION
   This cmdlet returns the alerts from the connected Arexdata Server. Use "Connect-ArexServer" to connect.
.EXAMPLE
   Get-ArexAlertSumary -RecordId xxxx-xxx-xxxx
#>
function Get-ArexIntegrations {
    $response = ArexPost("Integrator/All/0/100")
	$obj = $response.listdata.{$values}

	$prop = @('name','agentName')

	FormatArexResult $obj $prop 

}