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
	param ([string] $api, $body)
	$ProgressPreference = 'SilentlyContinue'

	if($null -ne $body){
		Invoke-RestMethod -Uri "https://$global:ArexServer/$api" -Method Post -Headers $global:ArexAuthHeader -Body (ConvertTo-Json -InputObject $body -Depth 10 -Compress)  -ContentType 'application/json'
	} else {
		Invoke-RestMethod -Uri "https://$global:ArexServer/$api" -Method Post -Headers $global:ArexAuthHeader -ContentType 'application/json'
	}
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





