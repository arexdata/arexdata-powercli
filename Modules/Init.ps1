if($PSVersionTable.PSVersion.Major -lt 3) {
	throw "Arexdata PowerCLI requires Powershell 3.0 or higher. You are running Powershell v" + $PSVersionTable.PSVersion
}

Remove-Module Arexdata -ErrorAction:SilentlyContinue
Import-Module $psscriptroot\Arexdata.psd1
