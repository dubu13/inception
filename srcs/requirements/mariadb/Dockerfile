# base image
FROM debian:bullseye

# install mariadb
RUN apt-get update & apt-get install -y mariadb-server

# copy configuration file
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# copy initialization script
COPY tools/init.sh /usr/local/bin

# make script executable
RUN chmod +x /usr/local/bin/

# mariadb default port

EXPOSE 3306

# run initialization script

CMD ["init.sh"]