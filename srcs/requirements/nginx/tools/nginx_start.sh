#!/bin/bash

# --- ÉTAPE 1 : SÉCURITÉ (Certificat SSL) ---
# On vérifie si on a déjà un cadenas (certificat) pour le site.
if [ ! -f /etc/ssl/certs/nginx.crt ]; then
    echo "Nginx: Création du cadenas de sécurité (SSL)...";
    
    # req -x509 : Crée un certificat auto-signé.
    # -nodes : Pas de mot de passe (pour que le serveur démarre sans intervention humaine).
    # -newkey rsa:4096 : Crée une clé de cryptage ultra-solide.
    # -subj : Remplit les informations d'identité (France, Paris, 42, etc.).
    openssl req -x509 -nodes -days 365 -newkey rsa:4096 \
        -keyout /etc/ssl/private/nginx.key \
        -out /etc/ssl/certs/nginx.crt \
        -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=irobinso.42.fr/UID=irobinso";
    
    echo "Nginx: Le cadenas SSL est prêt !";
fi

# --- ÉTAPE 2 : LANCEMENT FINAL ---
# exec "$@" : Exécute la commande passée dans la CMD du Dockerfile (nginx -g 'daemon off;').
# Cela permet à Nginx de devenir le processus principal (PID 1).
exec "$@"
