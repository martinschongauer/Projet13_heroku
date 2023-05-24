## Résumé

Site web d'Orange County Lettings

## Développement local

### Prérequis

- Compte GitHub avec accès en lecture à ce repository
- Git CLI
- SQLite3 CLI
- Interpréteur Python, version 3.6 ou supérieure

Dans le reste de la documentation sur le développement local, il est supposé que la commande `python` de votre OS shell exécute l'interpréteur Python ci-dessus (à moins qu'un environnement virtuel ne soit activé).

### macOS / Linux

#### Cloner le repository

- `cd /path/to/put/project/in`
- `git clone https://github.com/OpenClassrooms-Student-Center/Python-OC-Lettings-FR.git`

#### Créer l'environnement virtuel

- `cd /path/to/Python-OC-Lettings-FR`
- `python -m venv venv`
- `apt-get install python3-venv` (Si l'étape précédente comporte des erreurs avec un paquet non trouvé sur Ubuntu)
- Activer l'environnement `source venv/bin/activate`
- Confirmer que la commande `python` exécute l'interpréteur Python dans l'environnement virtuel
`which python`
- Confirmer que la version de l'interpréteur Python est la version 3.6 ou supérieure `python --version`
- Confirmer que la commande `pip` exécute l'exécutable pip dans l'environnement virtuel, `which pip`
- Pour désactiver l'environnement, `deactivate`

#### Exécuter le site

- `cd /path/to/Python-OC-Lettings-FR`
- `source venv/bin/activate`
- `pip install --requirement requirements.txt`
- `python manage.py runserver`
- Aller sur `http://localhost:8000` dans un navigateur.
- Confirmer que le site fonctionne et qu'il est possible de naviguer (vous devriez voir plusieurs profils et locations).

#### Linting

- `cd /path/to/Python-OC-Lettings-FR`
- `source venv/bin/activate`
- `flake8`

#### Tests unitaires

- `cd /path/to/Python-OC-Lettings-FR`
- `source venv/bin/activate`
- `pytest`

#### Base de données

- `cd /path/to/Python-OC-Lettings-FR`
- Ouvrir une session shell `sqlite3`
- Se connecter à la base de données `.open oc-lettings-site.sqlite3`
- Afficher les tables dans la base de données `.tables`
- Afficher les colonnes dans le tableau des profils, `pragma table_info(Python-OC-Lettings-FR_profile);`
- Lancer une requête sur la table des profils, `select user_id, favorite_city from
  Python-OC-Lettings-FR_profile where favorite_city like 'B%';`
- `.quit` pour quitter

#### Panel d'administration

- Aller sur `http://localhost:8000/admin`
- Connectez-vous avec l'utilisateur `admin`, mot de passe `Abc1234!`

### Windows

Utilisation de PowerShell, comme ci-dessus sauf :

- Pour activer l'environnement virtuel, `.\venv\Scripts\Activate.ps1` 
- Remplacer `which <my-command>` par `(Get-Command <my-command>).Path`

### Déploiement

Le code de l'application est déployé en continu à l'aide d'un pipeline CI/CD. Ce dernier s'appuie sur l'utilisation de CircleCI, qui récupère le code du dépot GitHub, effectue et les tests et (si ces derniers se passent sans erreur) construit une image Docker qui est ensuite déployée via l'hébergeur Heroku. Une copie de l'image est également placée sur DockerHub, et peut être récupérée et lancée en local afin de tester son fonctionnement.

Pour réaliser le déploiement, il faut:
- Disposer d'un dépot GitHub contenant le code de l'application
- Se connecter à CircleCI, en utilisant son compte GitHub
- Configurer le dépot pour que CircleCi déclenche la chaîne de déploiement à chaque commit sur la branche master, et définir le bon environnement dans les paramètres du projet

Six variables d'environnement sont nécessaires pour faire fonctionner le pipeline CI/CD:
DOCKER_LOGIN : L'identifiant du compte Docker vers lequel les images seront uploadées
DOCKER_PASSWORD : Le mot de passe correspondant
HEROKU_API_KEY : Clé générée par Heroku 
HEROKU_APP_NAME	: Nom de l'application Heroku
SECRET_KEY : La clé utilisée par Django dans le fichier settings.py pour sécuriser la base de données de l'application
SENTRY_ADDR	: L'adresse HTTP à laquelle le module sentry se connecte pour enregistrer les erreurs capturées

Ces variables d'environnement contiennent des données trop sensibles pour être stockées en clair sur GitHub, même sur un dépôt privé.

La création et la gestion d'une application Heroku se fait directement sur le portail web de l'hébergeur, à l'adresse:
https://id.heroku.com/login

Il en est de même de la capture des erreurs via le portail web de Sentry:
https://blog.sentry.io/monitoring-performance-and-errors-in-a-django-application-with-sentry/

L'utilisation de ces sites est intuitive et ne demande pas d'explications particulières. Il est possible d'utiliser un client en ligne de commande pour gérer les applications Heroku, mais ce n'est absolument pas nécessaire pour commencer.

On peut donner plus de détails sur la manière dont l'image générée par le pipeline et stockée sur le compte DockerHub peut être récupérée et manipulée en local.
Une fois connecté au site internet:

https://hub.docker.com/

Aller dans l'application, puis sur la page de l'image que l'on souhaite récupérer. Copier le titre de la page qui est le tag complet de l'image.
Sous Linux (avec l'utilisateur root) se logger à DockerHub:

`docker login --username <login> --password <pass>`

Pour récupérer l'image:

`docker login --username <login> --password <pass>`

`docker pull <tag_image>`

Pour voir les images présentes en local et les supprimer lorsqu'elles ne sont plus nécessaires:

`docker images`

`docker rmi <tag_image>`

Pour lancer l'image et voir les images qui sont en train de tourner:
`docker run --name django-test -d -p 8000:8000 <tag_image>`

`docker ps`

Dans la première commande, le nom du container fourni en paramètre peut être choisi librement tant qu'il n'a pas déjà été utilisé par un container précédant.
-d sert à libérer le terminal et à faire tourner en arrière-plan ("detach")
-p fixe le port local sur lequel le serveur sera accessible (premier paramètre). Le second numéro de port est choisi à la construction de l'image (ne pas modifier).

Pour arrêter un container qui tourne:
`docker stop <image_ID>`

On peut voir l'ensemble des containers qui ont tourné (incluant ceux qui ont été arrêtés) et supprimer les anciens containers:

`docker ps -a`
`docker rm <container_ID>`

On pourra alors visiter le site à l'adresse suivante:
127.0.0.1:8000/

Et déclencher une erreur de division par zéro à l'adresse suivante, pour tester Sentry:
127.0.0.1:8000/sentry-debug
