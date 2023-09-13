Get-ChildItem $psscriptroot\Modules\*.ps1 | % { 
    	Write-Host $_.FullName 
        . $_.FullName
    }