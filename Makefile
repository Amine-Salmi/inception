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

clean:
	@cd srcs && docker compose down -v

fclean: clean
	@sudo rm -rf ${HOME}/data/mariadb
	@sudo rm -rf ${HOME}/data/wordpress

re: fclean all

.PHOMY: all build up status logs logs-nginx logs-wordpress logs-mariadb clean fclean re