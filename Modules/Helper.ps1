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

function FormatArexResult{
	param(
		[object[]] $obj,  
		[object[]] $prop )

	if($obj) {
		$obj|%{
			$_.psTypeNames.Insert(0, "ArexObject")
		}
	
		Update-TypeData -Force -TypeName "ArexObject" -DefaultDisplayPropertySet $prop
		$obj
	}
}