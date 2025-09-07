---
- name: Installer IIS et créer un site web de test
  hosts: web1
  gather_facts: yes
  tasks:

    - name: Installer le rôle IIS de base avec les outils de gestion
      win_feature:
        name:
          - Web-Server
          - Web-Mgmt-Tools
        state: present
        include_management_tools: yes

    - name: Installer des fonctionnalités IIS supplémentaires
      win_feature:
        name:
          - Web-Common-Http
          - Web-Default-Doc
          - Web-Dir-Browsing
          - Web-Http-Errors
          - Web-Static-Content
        state: present

    - name: S'assurer que le service W3SVC (IIS) est démarré et activé
      win_service:
        name: W3SVC
        start_mode: auto
        state: started

    - name: Créer le dossier pour le site et ajouter index.html
      win_copy:
        dest: C:\inetpub\hexaltech.web\index.html
        content: "<h1>Hello Hexaltech!</h1>"

    - name: Créer le site web hexaltech.web
      win_iis_website:
        name: hexaltech.web
        state: started
        physical_path: C:\inetpub\hexaltech.web
        port: 80
