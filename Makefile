# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: juhanse <juhanse@student.s19.be>           +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/12/09 14:54:32 by juhanse           #+#    #+#              #
#    Updated: 2026/02/10 12:26:34 by juhanse          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME           = inception
DOCKER_COMPOSE = ./srcs/docker-compose.yml
DATA_PATH	   = /Users/julienhanse/data

GREEN          = \033[0;32m
RED            = \033[0;31m
RESET          = \033[0m

all: setup
	@echo "$(GREEN)Démarrage de $(NAME)...$(RESET)"
	docker compose -f $(DOCKER_CONFIG) up --build -d

setup:
	mkdir -p $(DATA_PATH)/mysql
	mkdir -p $(DATA_PATH)/wordpress

down:
	@echo "$(RED)Arrêt des containers...$(RESET)"
	docker compose -f $(DOCKER_CONFIG) down

clean: down
	@echo "$(RED)Suppression des images et du réseau...$(RESET)"
	docker compose -f $(DOCKER_CONFIG) down --rmi all

fclean: clean
	@echo "$(RED)Nettoyage complet - volumes et données locales...$(RESET)"
	docker compose -f $(DOCKER_CONFIG) down -v --rmi all
	rm -rf $(DATA_PATH)
	@docker system prune -af

re: fclean all

.PHONY: all setup down clean fclean re
