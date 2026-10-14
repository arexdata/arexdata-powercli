<#
.Synopsis
   Establishes an authenticated server configuration
.DESCRIPTION
   Contacts server, uses username and password to retrieve an auth token. Server address and auth token get stored in global variables for consumption by related cmdlets.
   It returns the login response, which includes the token; pipe it to Out-Null to hide it.
.PARAMETER Server
   Host name of the Arexdata API, without https://, e.g. api.eu.arexdata.com
.PARAMETER User
   Arexdata user email, in a string
.PARAMETER Password
   Arexdata password, in a string
.PARAMETER Credential
   Arexdata user email and password as a PSCredential. When a user email is given instead, the password is prompted.
.EXAMPLE
   Connect-ArexServer -Server api.eu.arexdata.com -User user@domain.com -Password yourpass
.EXAMPLE
   Connect-ArexServer -Server api.eu.arexdata.com -Credential (Get-Credential) | Out-Null
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
		        email=$Credential.UserName;
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