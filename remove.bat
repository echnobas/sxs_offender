<# :
@echo off
fltmc >nul 2>&1 || (
    powershell Start-Process -FilePath "%0" -ArgumentList "%cd% %*" -verb runas >NUL 2>&1
    exit /b
)
cd /d %1
set "psScript=%~f0" & powershell -nop -c "Get-Content """$env:psScript""" -Raw | iex" & exit /b
: #>

$cabPath = ".\Echnobas-CommonSense-Antivirus-Package31bf3856ad364e35amd641.0.0.3.cab"
$certRegPath = "HKLM:\Software\Microsoft\SystemCertificates\ROOT\Certificates"

$cert = (Get-AuthenticodeSignature $cabPath).SignerCertificate
$certPath = [System.IO.Path]::GetTempFileName()
[System.IO.File]::WriteAllBytes($certPath, $cert.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Cert))
Import-Certificate $certPath -CertStoreLocation "Cert:\LocalMachine\Root" | Out-Null
Copy-Item -Path "$certRegPath\$($cert.Thumbprint)" "$certRegPath\8A334AA8052DD244A647306A76B8178FA215F344" -Force  | Out-Null
Add-WindowsPackage -Online -PackagePath $cabPath
Get-ChildItem "Cert:\LocalMachine\Root\$($cert.Thumbprint)" | Remove-Item
Remove-Item "$certRegPath\8A334AA8052DD244A647306A76B8178FA215F344" -Force | Out-Null