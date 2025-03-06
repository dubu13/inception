#!/bin/bash

# reading secrets
MYSQL_PASSWORD=$(cat /run/secrets/db_user_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)


if [ ! -f "wp-config.php" ]; then
    echo "Create wp-config.php"
    wp core download --allow-root --path='/var/www/html'
    wp config create --allow-root \
        --dbname=$MYSQL_DATABASE \
        --dbuser=$MYSQL_USER \
        --dbpass=$MYSQL_PASSWORD \
        --dbhost=mariadb:3306 \
        --path='/var/www/html'

    wp core install --allow-root \
        --url="https://${DOMAIN_NAME}" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="admin@example.com" \
        --skip-email

    echo "Create WordPress user"
    wp user create --allow-root \
        dhasan admin2@example.com \
        --role=author \
        --user_pass="$WP_USER_PASSWORD"
fi

echo "Ensure PHP run directory exists"
mkdir -p /run/php

echo "Start PHP-FPM"
exec php-fpm7.4 -F