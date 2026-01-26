# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: juhanse <juhanse@student.s19.be>           +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/12/09 14:54:32 by juhanse           #+#    #+#              #
#    Updated: 2026/01/26 13:56:50 by juhanse          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME          = inception
DOCKER_CONFIG = ./srcs/docker-compose.yml
DATA_PATH     = /home/juhanse/data

GREEN         = \033[0;32m
RED           = \033[0;31m
RESET         = \033[0m

all: setup
	@echo "$(GREEN)Démarrage de l'infrastructure $(NAME)...$(RESET)"
	docker compose -f $(DOCKER_CONFIG) up --build -d

setup:
	@echo "$(GREEN)Création des répertoires de données dans $(DATA_PATH)...$(RESET)"
	@mkdir -p $(DATA_PATH)/wordpress
	@mkdir -p $(DATA_PATH)/mariadb

down:
	@echo "$(RED)Arrêt des containers...$(RESET)"
	docker compose -f $(DOCKER_CONFIG) down

clean: down
	@echo "$(RED)Suppression des images et du réseau...$(RESET)"
	docker compose -f $(DOCKER_CONFIG) down --rmi all

fclean: clean
	@echo "$(RED)Nettoyage complet (volumes et données locales)...$(RESET)"
	docker compose -f $(DOCKER_CONFIG) down -v --rmi all
	@sudo rm -rf $(DATA_PATH)
	@docker system prune -af

re: fclean all

.PHONY: all setup down clean fclean re
