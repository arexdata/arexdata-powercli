<#
.Synopsis
   Lists the Arexdata PowerCLI cmdlets and shows their help
.DESCRIPTION
   Without parameters, this cmdlet lists every Arexdata PowerCLI cmdlet with its synopsis.
   With a cmdlet name, it shows the full help of that cmdlet. No connection to an Arexdata Server is needed.
.PARAMETER Name
   Cmdlet to show the help of. Accepts wildcards; when it matches more than one cmdlet, they are listed instead.
.PARAMETER Examples
   Show only the examples of the cmdlet.
.EXAMPLE
   Get-ArexHelp
.EXAMPLE
   Get-ArexHelp Get-ArexAlerts
.EXAMPLE
   Get-ArexHelp Get-ArexAlerts -Examples
.EXAMPLE
   Get-ArexHelp *Alert*
#>
function Get-ArexHelp {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory=$false,Position=0)]
		[string] $Name = '*',

		[Parameter(Mandatory=$false)]
		[switch] $Examples
	)

	$commands = @(Get-Command -Module Arexdata -Name *-Arex* | Where-Object { $_.Name -like $Name } | Sort-Object Name)

	if ($commands.Count -eq 0) {
		throw "No Arexdata PowerCLI cmdlet matches '$Name'. Run Get-ArexHelp to list them."
	}

	if ($commands.Count -eq 1 -and ![WildcardPattern]::ContainsWildcardCharacters($Name)) {
		if ($Examples) { Get-Help $commands[0].Name -Examples } else { Get-Help $commands[0].Name -Full }
		return
	}

	$commands | ForEach-Object {
		[pscustomobject]@{ Cmdlet = $_.Name; Synopsis = ((Get-Help $_.Name).Synopsis -replace '\s+', ' ').Trim() }
	}
}
