<#
.Synopsis
   Establishes an authenticated server configuration
.DESCRIPTION
   Contacts server, uses username and password to retrieve an auth token. Server address and auth token get stored in global variables for consumption by related cmdlets.
.PARAMETER Server
   IP or URL of the target Arexdata Server
.PARAMETER User
   Arexdata Username, in a string
.PARAMETER Password
   Arexdata Password, in a string
.PARAMETER Credential
   Arexdata Username and Password in either PSCredential or domain\username format
.EXAMPLE
   Connect-ArexServer -Server api.dev.arexdata.com -User root -Password 12345
#>
function Connect-ArexServer {
	[CmdletBinding(
        DefaultParameterSetName="PSCred"
    )]
	param (
		[Parameter(Mandatory=$true,Position=0)]
		[string] $Server,
        [Parameter(Mandatory=$true,Position=1, ParameterSetName="UserPass")]
		[string] $User,
		[Parameter(Mandatory=$true,Position=2, ParameterSetName="UserPass")]
        [string] $Password,
        [Parameter(Mandatory=$true,Position=3,ParameterSetName="PSCred")]
		[System.Management.Automation.CredentialAttribute()] $Credential

	)
    
    Switch ($PsCmdlet.ParameterSetName){   
        "UserPass" {            
            $body =  @{
		        email=$User;
		        password=$Password;
	        }
        }
        "PSCred" {            
            $body =  @{
		        username=$Credential.UserName;
		        password=$Credential.GetNetworkCredential().Password;
	        }
        }   
    } 

	$response = Invoke-RestMethod -Uri "https://$Server/Authentication/Login" -Method Post -Body (ConvertTo-Json -InputObject $body) -ContentType 'application/json' 
	$response

	$global:ArexServer = $server
	$global:ArexAuthHeader =  @{
		Authorization="Bearer $($response.token)"
	}    
}