# Variables depuis Ansible Vault
$windows_user = "{{ windows_server_user }}"
$windows_password = "{{ windows_server_password_active_directory }}"
$domain_name = "{{ domain_name }}"

# Forme complète de l'utilisateur pour la tâche planifiée
$full_user = "$($domain_name.Split('.')[0])\$windows_user"

# Supprimer le lecteur Z: s'il existe déjà
try {
    Remove-PSDrive -Name Z -Force -ErrorAction Stop
} catch {
    Write-Host "Le lecteur Z: n'existait pas ou impossible de le supprimer."
}

# Chemin du script batch
$batPath = "C:\Scripts\map_drive.bat"

# Crée l'action pour exécuter le script batch
$action = New-ScheduledTaskAction -Execute "cmd.exe" -Argument "/c `"$batPath`""

# Déclencheur : au logon de l'utilisateur
$trigger = New-ScheduledTaskTrigger -AtLogOn

# Crée ou met à jour la tâche planifiée pour l'utilisateur
Register-ScheduledTask `
    -TaskName "MapZDrive" `
    -Action $action `
    -Trigger $trigger `
    -User $full_user `
    -Password $windows_password `
    -RunLevel Highest `
    -Force
