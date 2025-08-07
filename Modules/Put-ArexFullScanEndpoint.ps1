
<#
.Synopsis
   Gets Alerts from Arexdata
.DESCRIPTION
   This cmdlet returns the alerts from the connected Arexdata Server. Use "Connect-ArexServer" to connect.
.EXAMPLE
   Get-ArexAlertSumary -RecordId xxxx-xxx-xxxx
#>
function Put-ArexFullScanEndpoint {
    $body=@()
    ArexPut "Agent/FullScanSensitiveData" -body $body

}