<#
.Synopsis
   Gets the failed agent tasks from Arexdata
.DESCRIPTION
   This cmdlet returns the agent tasks that failed in the last 7 days in the connected Arexdata Server (up to 1000, newest first), with the agent, start and last update dates, status and result message. Use "Connect-ArexServer" to connect.
.EXAMPLE
   Get-ArexTasks
#>
function Get-ArexTasks {
    $filters = @(
        @{
            Filter          = "Equals"
            ExistsFilter    = $false
            NumberFilter    = "None"
            DateFilter      = "Relative"
            Column          = "LastUpdateAt"
            Value           = "LAST7DAYS"
            Sort            = "Descending"
        },
        @{
            Filter          = "Equals"
            ExistsFilter    = $false
            NumberFilter    = "None"
            DateFilter      = "None"
            Column          = "TaskStatus"
            Value           = "Failed"
            Sort            = "None"
        }
    )



        
    $response = ArexPost "AgentTask/0/1000" $filters
	$obj = $response.listdata.{$values}
   
    $prop = @(
        'agentName',
        'proxyConfigurationName'
        'startAt',
        'lastUpdateAt',
        'status',
        'resultMessage'
    )

	FormatArexResult $obj $prop 
}