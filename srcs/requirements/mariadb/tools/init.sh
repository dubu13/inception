#!bin/bash

# start mysql server
service mysql start

# wait for mysql to be ready
while ! mysqladmin ping -h "localhost" --silent; do
    echo "Waiting for MariaDB to start"
    sleep 1
done

# creating database
mysql -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"

# creating user
mysql -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"

# giving permission to user for database
mysql -e "CREATE ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"

# applying privileges changes
mysql -e "FLUSH PRIVILEGES;"

exec mysql-safe