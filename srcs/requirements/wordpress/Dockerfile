# 1. Base Debian Bullseye.
FROM debian:bullseye

# 2. Installation de PHP et de ses extensions.
# php-mysql : indispensable pour que WordPress puisse lire la base MariaDB.
# mariadb-client : permet d'utiliser la commande 'mysqladmin' pour tester la connexion.
RUN apt-get update && apt-get install -y \
    php7.4 \
    php-fpm \
    php-mysql \
    mariadb-client \
    wget \
    && rm -rf /var/lib/apt/lists/*

# 3. On informe Docker que ce container écoutera sur le port 9000.
EXPOSE 9000

# 4. On injecte la configuration PHP (www.conf) et l'ouvrier (le script .sh).
COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY ./tools/wordpress_start.sh /var/www/
RUN chmod +x /var/www/wordpress_start.sh

# 5. ENTRYPOINT : Au lancement, on active l'ouvrier pour installer WordPress.
ENTRYPOINT ["/var/www/wordpress_start.sh"]
