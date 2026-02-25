all: build up

build:
	@mkdir -p ${HOME}/data/mariadb
	@mkdir -p ${HOME}/data/wordpress
	@cd srcs && docker compose build

up:
	@cd srcs && docker compose up -d

down:
	@cd srcs && docker compose down

status:
	@cd srcs && docker compose ps

logs:
	@cd srcs && docker compose logs -f

logs-nginx:
	@cd srcs && docker compose logs -f nginx

logs-wordpress:
	@cd srcs && docker compose logs -f wordpress

logs-mariadb:
	@cd srcs && docker compose logs -f mariadb

logs-redis:
	@cd srcs && docker compose logs -f redis

logs-ftp:
	@cd srcs && docker compose logs -f ftp

clean:
	@cd srcs && docker compose down -v

fclean: clean
	@sudo rm -rf ${HOME}/data/mariadb
	@sudo rm -rf ${HOME}/data/wordpress

re: fclean all

.PHONY: all build up down status logs logs-nginx logs-wordpress logs-mariadb logs-redis logs-ftp clean fclean re