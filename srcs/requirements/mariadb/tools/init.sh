#!/bin/bash

# reading secrets
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
MYSQL_PASSWORD=$(cat /run/secrets/db_user_password)

# proper directory permissions
mkdir -p /var/run/mysqld
chown -R mysql:mysql /var/run/mysqld /var/lib/mysql
chmod 777 /var/run/mysqld

# initializing database if not done already
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# starting MariaDB in background for initialization
mysqld_safe --skip-grant-tables --skip-networking &

# waiting for MariaDB to be ready
until mysqladmin ping >/dev/null 2>&1; do
    echo "Waiting for MariaDB to start..."
    sleep 2
done

echo "MariaDB started, configuring..."

# configuring MariaDB
mysql -u root << EOF
FLUSH PRIVILEGES;
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${MYSQL_ROOT_PASSWORD}');
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

echo "Initial configuration done, restarting MariaDB..."

# shutdown MariaDB
mysqladmin -u root shutdown

echo "Starting MariaDB normally..."

# starting MariaDB normally
exec mysqld --user=mysql