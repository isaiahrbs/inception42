# Developer Documentation

## Setup Environment
1. Installez Docker et Docker-Compose sur votre machine.
2. Assurez-vous d'avoir les dossiers de données créés sur l'hôte : `/home/irobinso/data/mariadb` et `/home/irobinso/data/wordpress`.
3. Créez le fichier `srcs/.env` basé sur le modèle suivant :
   ```env
   MYSQL_ROOT_PASSWORD=votre_mot_de_passe_root
   MYSQL_DATABASE=wordpress
   MYSQL_USER=irobinso
   MYSQL_PASSWORD=votre_mot_de_passe_utilisateur
   WP_URL=https://irobinso.42.fr
   WP_TITLE="Mon Super Site Inception"
   WP_ADMIN_LOGIN=admin_user
   WP_ADMIN_PASSWORD=admin_password
   WP_ADMIN_EMAIL=admin@42.fr
   WP_USER_LOGIN=irobinso
   WP_USER_PASSWORD=user_password
   WP_USER_EMAIL=irobinso@42.fr
   ```

## Build & Launch
- `make all` : Construit les images et lance les conteneurs en mode détaché.
- `make re` : Force la reconstruction complète.

## Data Persistence
Les données persistent grâce à des volumes nommés (`db_data` et `wp_data`). Ils sont physiquement liés au dossier `/home/irobinso/data/` sur la machine hôte. Même après un `docker-compose down`, les données restent intactes.
