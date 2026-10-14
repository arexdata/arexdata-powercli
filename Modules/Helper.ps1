function CheckConnection {
	if(!$global:ArexAuthHeader)
	{
		throw "You are not currently connected to any server. Please connect first using  Connect-ArexServer cmdlet. `r`n" 		
	}
}

function ArexGet {
	param ([string] $api)
	$ProgressPreference = 'SilentlyContinue'
	Invoke-RestMethod -Uri "https://$global:ArexServer/$api" -Method Get -Headers $global:ArexAuthHeader -ContentType 'application/json'
}


function ArexPost {
	param ([string] $api, $body, [hashtable] $extraHeaders)
	$ProgressPreference = 'SilentlyContinue'

	$headers = $global:ArexAuthHeader
	if($extraHeaders){
		$headers = $global:ArexAuthHeader.Clone()
		foreach($key in $extraHeaders.Keys){ $headers[$key] = $extraHeaders[$key] }
	}

	if($null -ne $body){
		Invoke-RestMethod -Uri "https://$global:ArexServer/$api" -Method Post -Headers $headers -Body (ConvertTo-Json -InputObject $body -Depth 10 -Compress)  -ContentType 'application/json'
	} else {
		Invoke-RestMethod -Uri "https://$global:ArexServer/$api" -Method Post -Headers $headers -ContentType 'application/json'
	}
}

function ArexValues {
	param ($obj)
	# The API serializes arrays as { "$id": ..., "$values": [...] }
	if ($null -ne $obj -and $obj.PSObject.Properties['$values']) { $obj.{$values} } else { $obj }
}

function ArexTimeOffset {
	# Browser convention (UTC - local, in minutes), as the web UI sends it, so date ranges match the dashboards
	@{ TimeOffset = [string](-[int][TimeZoneInfo]::Local.GetUtcOffset((Get-Date)).TotalMinutes) }
}

function ArexFilter {
	param (
		[string] $column,
		[string] $value,
		[string] $dateFilter = "None",
		[string] $sort = "None",
		[string] $filter = "Equals"
	)
	@{
		Filter          = $filter
		ExistsFilter    = $false
		NumberFilter    = "None"
		DateFilter      = $dateFilter
		Column          = $column
		Value           = $value
		Sort            = $sort
	}
}

function ArexPostList {
	# $api must contain {skip} and {take}, e.g. "AgentTask/{skip}/{take}". $first = 0 returns every page.
	param ([string] $api, $body, [int] $first = 0, [int] $pageSize = 500)

	$limit = if ($first -gt 0) { $first } else { [int]::MaxValue }
	$returned = 0

	do {
		$take = [Math]::Min($pageSize, $limit - $returned)
		$response = ArexPost $api.Replace('{skip}', $returned).Replace('{take}', $take) $body (ArexTimeOffset)
		$items = @(ArexValues $response.listData)
		$items
		$returned += $items.Count
	} while ($items.Count -eq $take -and $returned -lt $limit -and ($null -eq $response.total -or $returned -lt $response.total))
}

function ArexPut {
	param ([string] $api, $body)
	$ProgressPreference = 'SilentlyContinue'
	if($null -ne $body){
		Invoke-RestMethod -Uri "https://$global:ArexServer/$api" -Method Put -Headers $global:ArexAuthHeader -Body (ConvertTo-Json -InputObject $body -Depth 10 -Compress)  -ContentType 'application/json'
	} else {
		Invoke-RestMethod -Uri "https://$global:ArexServer/$api" -Method Put -Headers $global:ArexAuthHeader -ContentType 'application/json'
	}
}

function FormatArexResult {
    param(
        [object[]] $obj,  
        [object[]] $prop 
    )

    if ($obj) {
        # Lista para almacenar los objetos modificados
        $filteredObjects = @()

        # Loop a través de cada objeto
        $obj | ForEach-Object {
            $objItem = $_
            
            # Crear un nuevo objeto vacío para almacenar solo las propiedades deseadas
            $newObj = New-Object PSObject

            # Agregar solo las propiedades que están en la lista de propiedades ($prop)
            foreach ($p in $prop) {
                if ($objItem.PSObject.Properties[$p]) {
                    # Agregar la propiedad al nuevo objeto
                    $newObj | Add-Member -MemberType NoteProperty -Name $p -Value $objItem.$p
                }
            }

            # Agregar el objeto filtrado a la lista
            $filteredObjects += $newObj
        }

        # Devolver los objetos filtrados
        return $filteredObjects
    }
}





