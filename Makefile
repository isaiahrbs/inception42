# Charger les variables du .env pour les raccourcis
MYSQL_USER = $(shell grep MYSQL_USER srcs/.env | cut -d '=' -f 2)
MYSQL_DATABASE = $(shell grep MYSQL_DATABASE srcs/.env | cut -d '=' -f 2)

all:
	@mkdir -p /home/irobinso/data/wordpress
	@mkdir -p /home/irobinso/data/mariadb
	@echo "Lancement de l'infrastructure Inception (Build + Up)..."
	@docker-compose -f ./srcs/docker-compose.yml up -d --build

# Raccourcis de contrôle
up:
	@echo "Démarrage des containers..."
	@docker-compose -f ./srcs/docker-compose.yml up -d

stop:
	@echo "Mise en veille des containers (STOP)..."
	@docker-compose -f ./srcs/docker-compose.yml stop

start:
	@echo "Réveil des containers (START)..."
	@docker-compose -f ./srcs/docker-compose.yml start

down:
	@echo "Arrêt et suppression des containers (DOWN)..."
	@docker-compose -f ./srcs/docker-compose.yml down

re:
	@echo "Redémarrage complet de l'infrastructure..."
	@docker-compose -f ./srcs/docker-compose.yml down
	@docker-compose -f ./srcs/docker-compose.yml up -d --build

# Inspection
ps:
	@echo "État des containers :"
	@docker-compose -f ./srcs/docker-compose.yml ps -a

logs:
	@echo "Affichage des logs (Ctrl+C pour quitter) :"
	@docker-compose -f ./srcs/docker-compose.yml logs -f

db:
	@echo "--------------------------------------------------------"
	@echo "CONSEIL : Tape ton mot de passe du .env."
	@echo "Une fois dedans, tape : SHOW TABLES; ou SELECT * FROM wp_users;"
	@echo "Tape 'exit;' pour quitter."
	@echo "--------------------------------------------------------"
	@docker exec -it mariadb mysql -u $(MYSQL_USER) -p $(MYSQL_DATABASE)

wp:
	@echo "--------------------------------------------------------"
	@echo "Bienvenue dans le container WordPress !"
	@echo "Le code source est dans /var/www/html/"
	@echo "Tape 'exit' pour quitter."
	@echo "--------------------------------------------------------"
	@docker exec -it wordpress bash

# Nettoyage
clean:
	@echo "Nettoyage des containers et des images..."
	@docker-compose -f ./srcs/docker-compose.yml down --rmi all --volumes
	@rm -rf /home/irobinso/data/wordpress
	@rm -rf /home/irobinso/data/mariadb

fclean: clean
	@echo "Nettoyage complet du système Docker (Prune)..."
	@docker system prune -a --force

.PHONY: all re down clean fclean ps logs db wp up stop start
