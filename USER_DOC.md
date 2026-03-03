# User Documentation

## Services provided
- **Nginx** : Serveur web sécurisé (TLS 1.2/1.3) servant de porte d'entrée unique.
- **WordPress** : Système de gestion de contenu (CMS) pour le site web.
- **MariaDB** : Base de données relationnelle stockant les articles et utilisateurs.

## Getting Started
- **Démarrage** : Tapez `make` à la racine.
- **Arrêt** : Tapez `make down`.

## Access
- **Site Web** : `https://irobinso.42.fr`
- **Panel Administration** : `https://irobinso.42.fr/wp-admin`

## Credentials
Les identifiants ne sont pas stockés dans le dépôt Git. Vous devez les définir dans le fichier `srcs/.env` avant le premier lancement.

## Health Check
Vérifiez l'état des services avec : `make ps`. Tous les conteneurs doivent afficher le statut "Up".
