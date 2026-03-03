#!/bin/bash

# --- ÉTAPE 1 : PRÉPARATION DES DOSSIERS ---
# MariaDB a besoin d'un dossier pour son 'socket' (son badge d'identité pour parler aux autres).
# -p : Crée les dossiers manquants et ne plante pas si ça existe déjà.
mkdir -p /run/mysqld
# -R : Donne la propriété de tout le dossier à l'utilisateur 'mysql' (le seul autorisé à y toucher).
chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql

# --- ÉTAPE 2 : INITIALISATION (Première fois seulement) ---
# On vérifie si la base de données est vide (si le dossier /mysql n'est pas là).
# C'est ce qui permet la PERSISTANCE : si les données sont déjà là, on ne touche à rien.
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "MariaDB : Première installation détectée, création des fichiers système..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql --skip-test-db >> /dev/null
fi

# --- ÉTAPE 3 : CONFIGURATION DES ACCÈS (Le coffre-fort) ---
# On lance MariaDB temporairement en arrière-plan (&) pour lui donner nos ordres SQL.
# --skip-networking : On coupe le réseau pendant 5 secondes pour régler les mots de passe en toute sécurité.
mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking &
pid="$!"

# On attend que le moteur soit bien allumé avant de lui parler.
until mysqladmin ping >/dev/null 2>&1; do
  echo "MariaDB : Réveil du moteur en cours..."
  sleep 1
done

# mysql -e (Execute) : Imagine que MariaDB est une personne. Au lieu de rentrer dans son bureau, 
# tu lui envoies une lettre (-e) avec un ordre précis dedans.

# Ordre 1 : Crée la pièce 'wordpress' pour ranger les données du site.
mysql -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
# Ordre 2 : Crée l'employé 'irobinso' avec son mot de passe.
# @'%' : Le 'VIP Pass' qui l'autorise à se connecter depuis le container WordPress (via le réseau).
mysql -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
# Ordre 3 : Donne à cet employé les clés de la pièce 'wordpress'.
mysql -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';"
# Ordre 4 : Sécurise le compte 'root' (le patron) avec un mot de passe solide.
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
# Ordre 5 : Valide tous les changements immédiatement.
mysql -e "FLUSH PRIVILEGES;"

# --- ÉTAPE 4 : PASSAGE AU MODE FINAL ---
# On éteint proprement l'instance temporaire de configuration.
mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown
wait "$pid"

echo "MariaDB : Configuration terminée. Lancement du serveur final !"

# exec : REMPLACE ce script par MariaDB au premier plan (PID 1).
# Le container restera allumé tant que MariaDB tourne.
exec mysqld --user=mysql --datadir=/var/lib/mysql
