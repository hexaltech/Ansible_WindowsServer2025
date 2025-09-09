#!/bin/bash
# vault_setup.sh - Tuto simple pour Ansible Vault avec variables

# --- 1️⃣ Variables d'environnement ---
export VAULT_PASS=~/.vault_pass.txt
export VAULT_FILE=~/Ansible_WindowsServer/group_vars/all/vault.yml

# --- 2️⃣ Créer le fichier contenant le mot de passe Vault ---
echo "Lemotdepassedevault*" > "$VAULT_PASS"
chmod 600 "$VAULT_PASS"

# --- 3️⃣ Créer le dossier pour le Vault si nécessaire ---
mkdir -p ~/Ansible_WindowsServer/group_vars/all

# --- 4️⃣ Créer le fichier Vault chiffré ---
ansible-vault create "$VAULT_FILE" --vault-password-file "$VAULT_PASS"

# --- 5️⃣ Ajouter des secrets ---
# L’éditeur s’ouvre : tu peux ajouter tes mots de passe Windows, clés API, etc.

# --- 6️⃣ Afficher le contenu du Vault ---
# Contenu chiffré
cat "$VAULT_FILE"
# Contenu en clair
ansible-vault view "$VAULT_FILE" --vault-password-file "$VAULT_PASS"

# --- 7️⃣ Modifier le Vault ---
EDITOR=nano ansible-vault edit "$VAULT_FILE" --vault-password-file "$VAULT_PASS"

# --- 8️⃣ Tester la connexion aux hôtes Windows via WinRM ---
ansible -i hosts.yml all -m win_ping --vault-password-file "$VAULT_PASS"

# --- 9️⃣ Lancer un playbook en utilisant le Vault ---
ansible-playbook -i hosts.yml 03_IIS/anydesk.yml --vault-password-file "$VAULT_PASS"
