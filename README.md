# Ansible Windows Server

Ce projet propose un ensemble de **playbooks Ansible** pour automatiser l’administration et le déploiement de rôles sur des serveurs Windows.  
Il couvre notamment la configuration de **WinRM**, l’installation et la gestion de **Active Directory**, la mise en place de **partages réseau**, le déploiement de **sites IIS** ainsi que la gestion des **mises à jour Windows**.

---

## 📂 Structure du projet

```
Ansible_WindowsServer/
├── hosts.yml                # Inventaire des hôtes Windows
├── reboot.yml               # Playbook de redémarrage
├── 00_Ansible_WinRM/        # Préparation de la communication Ansible <-> Windows
│   ├── install_ansible.sh
│   ├── WinRM_https.ps1
│   └── Prérequis
├── 01_Active_Directory/     # Déploiement et gestion de l'AD
│   ├── deploy_ad.yml
│   ├── AD_create_groups_users.yml
│   └── join_domain.yml
├── 02_Partage_DATAS/        # Partages réseau & mapping de lecteurs
│   ├── partage_data.yml
│   ├── map_drive_ansible.yml
│   └── files/
│       ├── AnyDesk.exe
│       ├── map_drive.bat
│       └── map_drive.ps1
├── 03_IIS/                  # Déploiement d’IIS et d’applications
│   ├── IIS_HexaltechWEB.yml
│   └── anydesk.yml
└── 04_WindowsUpdate/        # Gestion des mises à jour Windows
    └── win_updates
```

---

## ⚙️ Prérequis

- **Linux** avec Ansible installé (Ubuntu/Debian recommandé).  
- **Python 3** et `ansible-core`.  
- Un ou plusieurs serveurs **Windows Server** accessibles via WinRM (HTTPS).  
- Scripts de configuration WinRM (fournis dans `00_Ansible_WinRM/`).  
- **Nom de serveur et mot de passe de session** doivent être définis dans le fichier `hosts.yml` pour que les playbooks puissent fonctionner.

---

## 🚀 Installation

1. **Installer Ansible** (si ce n’est pas déjà fait) :
   ```bash
   sudo apt update && sudo apt install -y ansible
   ```

2. **Configurer WinRM sur Windows Server** :  
   - Exécuter `WinRM_https.ps1` en tant qu’administrateur.  
   - Vérifier la connectivité depuis la machine Ansible :  
     ```bash
     ansible -i hosts.yml all -m win_ping
     ```

3. **Adapter l’inventaire `hosts.yml`** avec vos serveurs Windows :
   ```yaml
   all:
     hosts:
       MON_SERVEUR_WINDOWS:
         ansible_host: 192.168.1.10
         ansible_user: Administrateur
         ansible_password: "VotreMotDePasse"
         ansible_connection: winrm
         ansible_winrm_transport: basic
   ```

---

## ▶️ Utilisation

### 1. Déploiement Active Directory
```bash
ansible-playbook -i hosts.yml 01_Active_Directory/deploy_ad.yml
```

### 2. Ajouter des utilisateurs/groupes AD
```bash
ansible-playbook -i hosts.yml 01_Active_Directory/AD_create_groups_users.yml
```

### 3. Joindre un poste au domaine
```bash
ansible-playbook -i hosts.yml 01_Active_Directory/join_domain.yml
```

### 4. Partages réseau & mapping de lecteurs
```bash
ansible-playbook -i hosts.yml 02_Partage_DATAS/partage_data.yml
```

### 5. Déploiement IIS
```bash
ansible-playbook -i hosts.yml 03_IIS/IIS_HexaltechWEB.yml
```

### 6. Gestion des mises à jour Windows
```bash
ansible-playbook -i hosts.yml 04_WindowsUpdate/win_updates
```

---

## 🛠️ Maintenance

- Pour redémarrer un serveur :
  ```bash
  ansible-playbook -i hosts.yml reboot.yml
  ```

---

## 📌 Notes

- Le fichier `AnyDesk.exe` est fourni pour automatiser l’installation de l’outil de support distant.  
- Les scripts `.bat` et `.ps1` dans `02_Partage_DATAS/files/` permettent de mapper les lecteurs réseau.  
- Assurez-vous d’avoir bien défini le **nom de serveur et le mot de passe** dans votre fichier `hosts.yml`.  

---

## 📄 Licence

Projet développé à des fins pédagogiques et administratives internes.  
Vous êtes libre de l’adapter selon vos besoins.
