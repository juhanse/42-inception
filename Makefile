# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: juhanse <juhanse@student.s19.be>           +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/12/09 14:54:32 by juhanse           #+#    #+#              #
#    Updated: 2026/01/29 01:02:04 by juhanse          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME          = inception
DOCKER_CONFIG = ./srcs/docker-compose.yml

GREEN         = \033[0;32m
RED           = \033[0;31m
RESET         = \033[0m

all:
	@echo "$(GREEN)Démarrage de $(NAME)...$(RESET)"
	docker compose -f $(DOCKER_CONFIG) up --build -d

down:
	@echo "$(RED)Arrêt des containers...$(RESET)"
	docker compose -f $(DOCKER_CONFIG) down

clean: down
	@echo "$(RED)Suppression des images et du réseau...$(RESET)"
	docker compose -f $(DOCKER_CONFIG) down --rmi all

fclean: clean
	@echo "$(RED)Nettoyage complet - volumes et données locales...$(RESET)"
	docker compose -f $(DOCKER_CONFIG) down -v --rmi all
	@docker system prune -af

re: fclean all

.PHONY: all down clean fclean re
