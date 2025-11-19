<#
.Synopsis
   Get Agent Tasks from Arexdata
.DESCRIPTION
   This cmdlet returns the tasks from the connected Arexdata Server. Use "Connect-ArexServer" to connect.
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
	$obj = $response.listdata
    $obj.{$values}
    return
    $prop = @(
        'agentName',
        'startAt',
        'lastUpdateAt',
        'status',
        'resultMessage'
    )

	FormatArexResult $obj $prop 
}