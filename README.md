*This project has been created as part of the 42 curriculum by irobinso.*

## Description
Inception est un projet d'infrastructure système utilisant Docker. L'objectif est de mettre en place une architecture micro-services composée de Nginx (serveur web), WordPress + PHP-FPM (moteur de site) et MariaDB (base de données), tous isolés dans des conteneurs dédiés communiquant via un réseau privé virtuel.

## Instructions
1. Clonez le dépôt.
2. Créez un fichier `srcs/.env` avec vos identifiants (voir `DEV_DOC.md`).
3. Lancez le projet avec : `make` (ou `make all`).
4. Accédez au site sur : `https://irobinso.42.fr`.

## Project Design Choices
- **VM vs Docker** : Contrairement à une VM qui émule un système d'exploitation complet (lourd en ressources), Docker partage le noyau de l'hôte et n'isole que les processus, ce qui est beaucoup plus léger.
- **Secrets vs Env Variables** : Les variables d'environnement sont pratiques mais visibles dans les commandes système. Les secrets Docker (non implémentés ici mais recommandés) offrent une couche de cryptage supplémentaire.
- **Docker Network vs Host Network** : Le réseau `bridge` (celui utilisé) isole les conteneurs du réseau de l'hôte, ne laissant passer que les ports explicitement exposés (443 ici).
- **Docker Volumes vs Bind Mounts** : Les volumes nommés (utilisés ici) sont gérés par Docker et offrent une meilleure portabilité et performance que les bind mounts classiques.

## Resources
- Documentation officielle de Docker & Docker Compose.
- **AI Usage** : L'IA a été utilisée pour l'aide à la rédaction de la documentation Markdown et pour la clarification des concepts de réseau (DNS interne Docker) et de gestion des processus (PID 1).
