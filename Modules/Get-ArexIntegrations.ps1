

<#
.Synopsis
   Gets the integrations from Arexdata
.DESCRIPTION
   This cmdlet returns the first 100 integrations (data sources such as file servers, Microsoft 365 or cloud storage) configured in the connected Arexdata Server, with the agent that collects each one. Use "Connect-ArexServer" to connect.
.EXAMPLE
   Get-ArexIntegrations
#>
function Get-ArexIntegrations {
    $response = ArexPost("Integrator/All/0/100")
	$obj = $response.listdata.{$values}

	$prop = @('name','agentName')

	FormatArexResult $obj $prop 

}