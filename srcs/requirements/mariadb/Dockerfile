# base image
FROM debian:bullseye

# install mariadb
RUN apt-get update -y && apt upgrade -y && apt-get install -y mariadb-server

# copy configuration file
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# copy initialization script
COPY tools/init.sh /usr/local/bin

# make script executable
RUN chmod +x /usr/local/bin/init.sh && \
    mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld && \
    chmod 777 /var/run/mysqld

# mariadb default port

EXPOSE 3306

# run initialization script

CMD ["/usr/local/bin/init.sh"]