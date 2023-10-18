Write-Host ""
Write-Host "[*] Welcome to Arexdata PowerCLI! ---------------------------------------------------------"
Write-Host ""
#Write-Host "    Sample usage:"
#Write-Host ""
#Write-Host "            Get-ArexHelp"
#Write-Host "            Connect-ArexServer -Server api.eu.arexdata.com -User user@domain.com -Password yourpass"
#Write-Host "            Get-ArexAlert -RecordID xxxx"
#Write-Host ""
#Write-Host ""
#Write-Host "    Copyright (C) Arexdata Ltd. All rights reserved."
#Write-Host "------------------------------------------------------------------------------------------------------"
#Write-Host ""

Get-ChildItem $psscriptroot\Modules\*.ps1 | % { 
#	Write-Host $_.FullName 
	. $_.FullName
}

# ignore certs for https
if ($PSVersionTable.PSEdition -eq 'Core') {
	# Invoke-restmethod provide Skip certcheck param in powershell core
    $Script:PSDefaultParameterValues = @{
    	"invoke-restmethod:SkipCertificateCheck" = $true
        "invoke-webrequest:SkipCertificateCheck" = $true  }          
} else {
#	add-type @"
#	    using System.Net;
#	    using System.Security.Cryptography.X509Certificates;
#	    public class TrustAllCertsPolicy : ICertificatePolicy {
#	        public bool CheckValidationResult(
#	            ServicePoint srvPoint, X509Certificate certificate,
#	            WebRequest request, int certificateProblem) {
#	            return true;
#	        }
#	    }
#"@

#	[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
#	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Ssl3, [Net.SecurityProtocolType]::Tls, [Net.SecurityProtocolType]::Tls12
}
