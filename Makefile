# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: juhanse <juhanse@student.s19.be>           +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/12/09 14:54:32 by juhanse           #+#    #+#              #
#    Updated: 2026/01/24 14:59:55 by juhanse          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

all:
	mkdir -p /home/juhanse/data/mariadb
	mkdir -p /home/juhanse/data/wordpress
	sudo docker compose -f ./srcs/docker-compose.yml up -d --build

down:
	docker compose -f ./srcs/docker-compose.yml down

clean:
	sudo docker compose -f ./srcs/docker-compose.yml down --rmi all -v

fclean: clean
	sudo rm -rf /home/juhanse/data/*

re: fclean all

.PHONY: all re down clean fclean
