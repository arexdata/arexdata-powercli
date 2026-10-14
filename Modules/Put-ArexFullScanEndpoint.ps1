
<#
.Synopsis
   Requests a full sensitive data scan on endpoints
.DESCRIPTION
   This cmdlet asks the connected Arexdata Server to run a full sensitive data scan on the given endpoints, the same as the "Full scan sensitive data" action of the web console. Use "Connect-ArexServer" to connect.
   Every endpoint received from the pipeline is sent in a single request. It returns True when the scan was scheduled.
   The server rejects the request when the organization has no global endpoint data classification policy configured.
.PARAMETER EndpointId
   Id of the endpoints to scan, as returned in the id column of Get-ArexEndpoints. Accepts the ids, or the Get-ArexEndpoints rows, from the pipeline.
.EXAMPLE
   Put-ArexFullScanEndpoint -EndpointId 3f2b8c1e-0d4a-4c55-9a7e-2b1f6c9d8e01
.EXAMPLE
   Get-ArexEndpoints -Name LAPTOP-* -Online | Put-ArexFullScanEndpoint
.EXAMPLE
   Get-ArexEndpoints | Put-ArexFullScanEndpoint -WhatIf
#>
function Put-ArexFullScanEndpoint {
	[CmdletBinding(SupportsShouldProcess=$true)]
	param(
		[Parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
		[Alias('id')]
		[guid[]] $EndpointId
	)

	begin {
		CheckConnection
		$ids = New-Object System.Collections.Generic.List[string]
	}

	process {
		foreach ($id in $EndpointId) { $ids.Add($id.ToString()) }
	}

	end {
		if ($ids.Count -and $PSCmdlet.ShouldProcess("$($ids.Count) endpoint(s)", "Full sensitive data scan")) {
			ArexPut "Agent/FullScanSensitiveData" -body $ids.ToArray()
		}
	}
}
