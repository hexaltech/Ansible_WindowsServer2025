# Ansible Windows Server

Ce projet propose un ensemble de playbooks Ansible pour automatiser l’administration et le déploiement de rôles sur des serveurs Windows.
Il couvre notamment la configuration de WinRM, l’installation et la gestion de Active Directory, la mise en place de partages réseau, le déploiement de sites IIS ainsi que la gestion des mises à jour Windows.

---

## 🐂 Structure du projet

```
Ansible_WindowsServer/
├── hosts.yml                     # Inventaire des hôtes Windows
├── reboot.yml                    # Playbook de redémarrage
├── 00_Ansible_WinRM/             # Préparation de la communication Ansible <-> Windows
│   ├── install_ansible.sh
│   ├── WinRM_https.ps1
│   └── Prérequis
├── 01_Active_Directory/          # Déploiement et gestion de l'AD
│   ├── deploy_ad.yml
│   ├── AD_create_groups_users.yml
│   └── join_domain.yml
├── 02_Partage_DATAS/             # Partages réseau & mapping de lecteurs
│   ├── partage_data.yml
│   ├── map_drive_ansible.yml
│   └── files/
│       ├── AnyDesk.exe
│       ├── map_drive.ps1.j2  
├── 03_IIS/                       # Déploiement d’IIS et d’applications
│   ├── IIS_HexaltechWEB.yml
│   └── anydesk.yml
└── 04_WindowsUpdate/             # Gestion des mises à jour Windows
    └── win_updates
├── group_vars/all/                # Variables globales, y compris Vault
│   └── vault.yml
```

---

## ⚙️ Prérequis

* **Linux** avec Ansible installé (Ubuntu/Debian recommandé).
* **Python 3**, `python3-venv` et `pip`.
* **Machine Ansible** : Debian 12 avec IP fixe (ex: `192.168.100.253`).
* **Serveurs Windows Server 2025** : DC1, FS1, WEB1

  * IP fixes : DC1=`192.168.100.250`, FS1=`192.168.100.251`, WEB1=`192.168.100.252`
  * Hostnames configurés
  * DNS pointant initialement vers DC1
  * Interface graphique ou CLI disponible
  * Tous les serveurs Windows doivent avoir RDP activé pour faciliter les tests.
* **WinRM HTTPS** configuré sur chaque serveur.
* **Compte Administrateur** avec mot de passe défini dans Vault ou hosts.yml.


---

## 🚀 Installation

### 1. Préparer l'environnement Ansible (venv)

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y python3 python3-venv python3-pip libkrb5-dev krb5-user git curl

# Créer le venv
python3 -m venv ~/ansible-venv
source ~/ansible-venv/bin/activate

# Installer Ansible et modules Windows
pip install --upgrade pip
pip install ansible pywinrm pypsrp requests-credssp requests-kerberos pyspnego
```

### 2. Configurer WinRM sur Windows Server

* Exécuter le script `WinRM_https.ps1` en tant qu’administrateur.
* Vérifier la connectivité depuis la machine Ansible :

```bash
ansible -i hosts.yml all -m win_ping
```

### 3. Configurer Vault (optionnel mais recommandé)

```bash
# Créer un fichier contenant le mot de passe Vault
echo "Lemotdepassedevault*" > ~/.vault_pass.txt
chmod 600 ~/.vault_pass.txt

# Créer le fichier Vault chiffré
mkdir -p ~/Ansible_WindowsServer/group_vars/all
ansible-vault create ~/Ansible_WindowsServer/group_vars/all/vault.yml --vault-password-file ~/.vault_pass.txt
```

* Ajouter vos secrets dans le Vault (ex: mots de passe Windows, clés API).
* Afficher ou modifier le Vault :

```bash
ansible-vault view ~/Ansible_WindowsServer/group_vars/all/vault.yml --vault-password-file ~/.vault_pass.txt
ansible-vault edit ~/Ansible_WindowsServer/group_vars/all/vault.yml --vault-password-file ~/.vault_pass.txt
```

---

## 📌 Inventaire exemple avec Vault

```yaml
all:
  hosts:
    dc1:
      ansible_host: 192.168.100.250
      ansible_user: Administrateur
      ansible_password: "{{ windows_server_user_password }}"
      ansible_connection: winrm
      ansible_winrm_transport: ntlm
      ansible_port: 5986
      ansible_winrm_server_cert_validation: ignore
```

---

## ▶️ Utilisation

1. **Déploiement Active Directory**

```bash
ansible-playbook -i hosts.yml 01_Active_Directory/deploy_ad.yml --vault-password-file ~/.vault_pass.txt
```

2. **Ajouter des utilisateurs/groupes AD**

```bash
ansible-playbook -i hosts.yml 01_Active_Directory/AD_create_groups_users.yml --vault-password-file ~/.vault_pass.txt
```

3. **Joindre un poste au domaine**

```bash
ansible-playbook -i hosts.yml 01_Active_Directory/join_domain.yml --vault-password-file ~/.vault_pass.txt
```

4. **Partages réseau & mapping de lecteurs**

```bash
ansible-playbook -i hosts.yml 02_Partage_DATAS/partage_data.yml --vault-password-file ~/.vault_pass.txt
```

5. **Déploiement IIS**

```bash
ansible-playbook -i hosts.yml 03_IIS/IIS_HexaltechWEB.yml --vault-password-file ~/.vault_pass.txt
```

6. **Gestion des mises à jour Windows**

```bash
ansible-playbook -i hosts.yml 04_WindowsUpdate/win_updates --vault-password-file ~/.vault_pass.txt
```

---

## 🛠️ Maintenance

Pour redémarrer un serveur :

```bash
ansible-playbook -i hosts.yml reboot.yml --vault-password-file ~/.vault_pass.txt
```

---

## 📌 Notes

* Le fichier `AnyDesk.exe` est fourni pour automatiser l’installation de l’outil de support distant.
* Les scripts `.bat` et `.ps1` dans `02_Partage_DATAS/files/` permettent de mapper les lecteurs réseau.
* Assurez-vous d’avoir bien défini le nom de serveur et le mot de passe dans **Vault** ou `hosts.yml`.
* Pour DC1, si le WinRM HTTPS ne fonctionne pas, vérifiez le certificat auto-signé et le FQDN dans le listener.

---

## 📄 Licence

Projet développé à des fins pédagogiques et administratives internes.
Vous êtes libre de l’adapter selon vos besoins.
