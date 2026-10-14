<#
.Synopsis
   Gets the endpoint agents from Arexdata
.DESCRIPTION
   This cmdlet returns the endpoint agents of the connected Arexdata Server: machine, IP, OS, agent version, online status, tags and id. Use "Connect-ArexServer" to connect.
   The id can be piped to Put-ArexFullScanEndpoint.
.PARAMETER Name
   Machine name to return. Accepts wildcards.
.PARAMETER Online
   Return only the endpoints that are currently online.
.PARAMETER First
   Maximum number of endpoints to return. 0 returns all of them.
.EXAMPLE
   Get-ArexEndpoints
.EXAMPLE
   Get-ArexEndpoints -Name LAPTOP-* -Online
.EXAMPLE
   Get-ArexEndpoints -Name LAPTOP-* | Put-ArexFullScanEndpoint
#>
function Get-ArexEndpoints {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory=$false,Position=0)]
		[string] $Name = '*',

		[Parameter(Mandatory=$false)]
		[switch] $Online,

		[Parameter(Mandatory=$false)]
		[int] $First = 0
	)

	CheckConnection
	$obj = ArexPostList "Agent/endpoints/{skip}/{take}" @() $First |
		Where-Object { $_.machineName -like $Name -and (!$Online -or $_.isOnline) }

	$prop = @(
		'machineName',
		'machineIP',
		'osVersion',
		'version',
		'isOnline',
		'lastConnectionAt',
		'labelsInString',
		'id'
	)

	FormatArexResult $obj $prop
}
