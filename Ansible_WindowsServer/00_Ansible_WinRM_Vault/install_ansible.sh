# On est hors du venv ici
sudo apt update
sudo apt upgrade -y

# Installer python3, venv, pip, et dépendances pour Kerberos
sudo apt install -y python3 python3-venv python3-pip libkrb5-dev krb5-user git curl


# Création du venv
python3 -m venv ~/ansible-venv

# Activation du venv
source ~/ansible-venv/bin/activate

# Vérifier que tu es bien dedans
which python
# doit pointer sur ~/ansible-venv/bin/python

# Installer Ansible
pip install --upgrade pip
pip install ansible

# Installer les modules pour gérer Windows
pip install pywinrm pypsrp requests-credssp requests-kerberos pyspnego

mkdir -p ~/ansible
cd ~/ansible

# Pour tester la connexion avec vos serveurs windows :
ansible -i hosts.yml all -m win_ping

