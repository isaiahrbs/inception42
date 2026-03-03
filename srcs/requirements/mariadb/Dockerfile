# 1. On choisit la base : une version allégée de Linux appelée Debian Bullseye.
FROM debian:bullseye

# 2. On installe le logiciel MariaDB Server.
# RUN s'exécute lors de la création de l'IMAGE (le build).
RUN apt-get update && apt-get install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/*

# 3. On informe Docker que le container utilisera le port 3306.
EXPOSE 3306

# 4. On injecte nos réglages personnalisés (le fichier 50-server.cnf).
# Ce fichier contient 'bind-address = 0.0.0.0' pour autoriser les autres containers à entrer.
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/

# 5. On prépare l'ouvrier (le script .sh) qui va configurer les mots de passe.
COPY ./tools/mariadb_start.sh /var/www/
RUN chmod +x /var/www/mariadb_start.sh

# 6. ENTRYPOINT : Au lancement du CONTAINER, on active d'abord l'ouvrier.
ENTRYPOINT ["/var/www/mariadb_start.sh"]

# 7. CMD : Une fois que l'ouvrier a préparé le terrain, on lance le moteur MariaDB final.
CMD ["mysqld"]
