# 1. Récupérer automatiquement le nom de la machine
$hostname = $env:COMPUTERNAME

# 2. Créer un certificat auto-signé pour ce nom
$cert = New-SelfSignedCertificate -DnsName $hostname -CertStoreLocation Cert:\LocalMachine\My

# 3. Récupérer le Thumbprint du certificat
$thumbprint = $cert.Thumbprint

# 4. Supprimer les anciens listeners WinRM en HTTPS (s'il y en a)
Get-ChildItem WSMan:\localhost\Listener | Where-Object { $_.Keys -like "*Transport=HTTPS*" } | Remove-Item -Recurse -Force

# 5. Créer un nouveau listener WinRM en HTTPS avec le certificat
New-WSManInstance -ResourceURI winrm/config/Listener `
  -SelectorSet @{Address="*"; Transport="HTTPS"} `
  -ValueSet @{Hostname=$hostname; CertificateThumbprint=$thumbprint}

# 6. Vérifier si la règle de pare-feu existe déjà, sinon la créer
if (-not (Get-NetFirewallRule -Name "WinRM-HTTPS" -ErrorAction SilentlyContinue)) {
    New-NetFirewallRule -Name "WinRM-HTTPS" -DisplayName "WinRM over HTTPS" `
      -Protocol TCP -LocalPort 5986 -Action Allow -Direction Inbound
    Write-Host "Règle WinRM-HTTPS créée."
} else {
    Write-Host "Règle WinRM-HTTPS déjà existante, aucune action effectuée."
}

# 7. Vérifier que tout fonctionne
Write-Host "==== Listeners WinRM ===="
winrm enumerate winrm/config/listener

Write-Host "==== Test de connexion locale ===="

Test-NetConnection -ComputerName $hostname -Port 5986
