NAME = inception

all: up

up:
	@printf "Starting ${NAME}...\n"
	@docker compose -f srcs/docker-compose.yml up --build

down:
	@printf "Stopping ${NAME}...\n"
	@docker compose -f srcs/docker-compose.yml down

clean: down
	@printf "Cleaning ${NAME}...\n"
	@docker system prune -a
	@if [ "$$(docker volume ls -q)" ]; then \
			docker volume rm $$(docker volume ls -q); \
	fi

fclean: clean
	@printf "Full cleaning ${NAME}...\n"
	# @sudo rm -rf /home/dhasan/data/wordpress/*
	# @sudo rm -rf /home/dhasan/data/mariadb/*

re: fclean all

.PHONY: all up down clean fclean re