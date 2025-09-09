# Prérequis pour le projet Ansible Windows Server

## 1️⃣ Machines Windows Server 2025
| Nom de la VM | Rôle | IP fixe | Remarques |
|--------------|------|---------|------------|
| DC1          | Contrôleur de domaine (Domain Controller) | 192.168.100.250 | Hostname configuré, DNS primaire |
| FS1          | Serveur de fichiers | 192.168.100.251 | Hostname configuré |
| WEB1         | Serveur web | 192.168.100.252 | Hostname configuré |

- DNS : configuré sur DC1 comme serveur DNS principal.

## 2️⃣ Machine Debian 12 (Ansible)
| Nom de la VM | Rôle | IP fixe | Remarques |
|--------------|------|---------|------------|
| ansible_winserver2025 | Machine de contrôle Ansible | 192.168.100.253 | Interface graphique ou CLI |

- Servira à exécuter les playbooks Ansible sur les VMs Windows Server.

---

## ✅ Checklist de configuration avant de commencer

- [ ] Les trois VMs Windows Server sont créées et démarrées.
- [ ] Les adresses IP fixes sont configurées correctement.
- [ ] Les hostnames sont définis sur chaque VM.
- [ ] Le DNS sur DC1 est fonctionnel et accessible depuis FS1 et WEB1.
- [ ] La machine Debian 12 est installée et accessible via SSH.
- [ ] Python 3, pip et venv installés sur Debian 12.
- [ ] Environnement virtuel Ansible configuré (`ansible-venv`).
- [ ] WinRM activé et configuré sur toutes les VMs Windows Server.
- [ ] Partage de fichiers et permissions testés pour FS1 (si nécessaire pour playbooks).
- [ ] Test de connexion Ansible avec `win_ping` réussi pour toutes les VMs.

---

> 💡 Astuce : tu peux ajouter ce fichier `README.md` directement dans ton dépôt GitHub pour que chaque membre de ton équipe puisse suivre la configuration requise.
