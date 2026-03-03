#!/bin/bash

# --- ÉTAPE 1 : SYNCHRONISATION (L'attente) ---
# On lance une boucle : "Hé MariaDB, tu es réveillé ?" (mysqladmin ping).
# On ne peut pas installer WordPress si la base de données fait encore sa sieste.
# -hmariadb : On cherche la machine nommée 'mariadb' sur le réseau Docker.
echo "WordPress : attente de MariaDB..."
while ! mysqladmin ping -hmariadb -u${MYSQL_USER} -p${MYSQL_PASSWORD} --silent; do
    echo "WordPress : La base de données n'est pas encore prête, j'attends 2 secondes..."
    sleep 2
done

# --- ÉTAPE 2 : CONFIGURATION PHP ---
# PHP-FPM veut écouter sur un 'socket' (un fichier local) par défaut.
# On le force à écouter sur le port 9000 pour que Nginx puisse lui parler via le réseau.
sed -i "s/listen = \/run\/php\/php7.4-fpm.sock/listen = 9000/" "/etc/php/7.4/fpm/pool.d/www.conf";

# On crée le dossier pour l'identifiant de processus (PID).
mkdir -p /run/php/;

# --- ÉTAPE 3 : INSTALLATION AUTOMATIQUE ---
# On ne lance l'installation que si le fichier 'wp-config.php' n'existe pas encore.
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "WordPress : début de l'installation..."
    
    cd /var/www/html
    
    # A. Télécharger l'outil wp-cli (la télécommande de WordPress).
    if [ ! -f /usr/local/bin/wp ]; then
        wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
        chmod +x wp-cli.phar
        mv wp-cli.phar /usr/local/bin/wp
    fi

    # B. Télécharger les fichiers sources officiels de WordPress.
    if [ ! -f /var/www/html/index.php ]; then
        wp core download --allow-root
    fi

    # C. Créer le cerveau (wp-config.php) avec les accès au .env.
    # --dbhost=mariadb:3306 : On donne l'adresse GPS de la base de données.
    wp config create --allow-root \
        --dbname=${MYSQL_DATABASE} \
        --dbuser=${MYSQL_USER} \
        --dbpass=${MYSQL_PASSWORD} \
        --dbhost=mariadb:3306

    # D. Lancer l'installation finale du site (Titre, administrateur, email).
    wp core install --allow-root \
        --url=${WP_URL} \
        --title="${WP_TITLE}" \
        --admin_user=${WP_ADMIN_LOGIN} \
        --admin_password=${WP_ADMIN_PASSWORD} \
        --admin_email=${WP_ADMIN_EMAIL}

    # E. Créer le deuxième utilisateur obligatoire pour le projet.
    wp user create --allow-root \
        ${WP_USER_LOGIN} ${WP_USER_EMAIL} \
        --user_pass=${WP_USER_PASSWORD} \
        --role=author

    echo "WordPress : installation terminée avec succès !"
else
    echo "WordPress : déjà installé (données persistantes trouvées)."
fi

# On donne les clés de la maison (propriété) à 'www-data' (l'utilisateur du serveur web).
chown -R www-data:www-data /var/www/html

# --- ÉTAPE 4 : LANCEMENT FINAL (PID 1) ---
# exec : transforme le script en moteur PHP-FPM au premier plan (-F).
# Le container restera vivant tant que WordPress peut cuisiner des pages PHP.
echo "WordPress : démarrage de PHP-FPM..."
exec /usr/sbin/php-fpm7.4 -F
