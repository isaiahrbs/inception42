# 1. Base Debian Bullseye.
FROM debian:bullseye

# 2. Installation de Nginx (serveur web) et OpenSSL (pour le cadenas).
RUN apt-get update && apt-get install -y nginx openssl && \
    rm -rf /var/lib/apt/lists/*

# 3. On informe Docker que ce container utilisera le port sécurisé 443.
EXPOSE 443

# 4. On injecte notre configuration personnalisée (le fichier default).
COPY ./conf/default /etc/nginx/sites-available/default
# ln -sf : Crée un raccourci (lien symbolique) pour ACTIVER la configuration.
RUN ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# 5. On prépare l'ouvrier (nginx_start.sh) pour fabriquer les clés de sécurité.
COPY ./tools/nginx_start.sh /var/www/
RUN chmod +x /var/www/nginx_start.sh

# 6. ENTRYPOINT : Au lancement, on active l'ouvrier pour préparer le SSL.
ENTRYPOINT ["/var/www/nginx_start.sh"]

# 7. CMD : Une fois prêt, on lance le serveur Nginx au premier plan (daemon off).
# C'est vital pour que le container ne s'arrête pas.
CMD ["nginx", "-g", "daemon off;"]
