<#
.Synopsis
   Gets the Arexdata Server version
.DESCRIPTION
   This cmdlet returns the version of the connected Arexdata Server. Use "Connect-ArexServer" to connect.
.EXAMPLE
   Get-ArexVersion
#>
function Get-ArexVersion {
	[CmdletBinding()]
	param()

	CheckConnection
	$response = ArexGet "Version"

	[pscustomobject]@{ Server = $global:ArexServer; Version = $response }
}
