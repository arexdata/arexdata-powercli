##Download
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"

Write-Host "Downloading latest version ..." -ForegroundColor Cyan
$webclient = New-Object System.Net.WebClient
$url = "http://github.com/arexdata/arexdata-powercli/archive/master.zip"
$file = "$($env:TEMP)\Arexdata-Powercli.zip"
$webclient.DownloadFile($url,$file)


##Extract

Write-Host "Extracting latest version ..." -ForegroundColor Cyan
$targetondisk = "$($env:TEMP)"
$shell_app= New-object -com shell.application
$zip_file = $shell_app.namespace($file)
$destination = $shell_app.namespace($targetondisk)
$destination.Copyhere($zip_file.items(), 0x10)


##Install

Write-Host "Installing latest version ..." -ForegroundColor Cyan
$item = $targetondisk + "\arexdata-powercli\*"
$destination = "C:\Windows\System32\WindowsPowerShell\v1.0\Modules\arexdata-powercli\"
New-Item -ItemType Directory -Force -Path $destination
cpi $item -Destination $destination -Recurse -Force


##Validate

Write-Host "Validating install ..." -ForegroundColor Cyan
$testfile = 'C:\Windows\System32\WindowsPowerShell\v1.0\Modules\arexdata-powercli\Arexdata.psm1'
$TestPath = Test-Path $testfile

If ($TestPath -eq $True)
    
    {
    Write-Host "Importing Arexdata PowerCLI Module..." -ForegroundColor Cyan
    Import-Module Arexdata -Force
    Write-Host "Installation Complete and module loaded!" -ForegroundColor Green
    
    ##Cleanup
    
    $path = $targetondisk + "\arexdata-powercli"
    Remove-Item -Recurse $path -Force
    Remove-Item $file -Force
    
    ##END.
    }

Else 
{
    Write-Host "Installation Failed. Please check and try again." -ForegroundColor Red
}