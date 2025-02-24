#!/bin/bash

# reading secrets
MYSQL_PASSWORD=$(cat /run/secrets/db_user_password)
# WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
# WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

# waiting for mysql to be ready
while ! mysql -h mariadb -u ${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE} >/dev/null 2>&1; do
    echo "Waiting for MariaDB..."
    sleep 1
done

# geting authentication keys
KEYS=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)

# creating new wp-config.php
cat > /var/www/html/wordpress/wp-config.php << EOF
<?php
define( 'DB_NAME', '${MYSQL_DATABASE}' );
define( 'DB_USER', '${MYSQL_USER}' );
define( 'DB_PASSWORD', '${MYSQL_PASSWORD}' );
define( 'DB_HOST', 'mariadb' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );

$KEYS

\$table_prefix = 'wp_';
define( 'WP_DEBUG', false );

if ( ! defined( 'ABSPATH' ) ) {
    define( 'ABSPATH', __DIR__ . '/' );
}

require_once ABSPATH . 'wp-settings.php';
EOF

# update ownership
chown www-data:www-data /var/www/html/wordpress/wp-config.php
# start php-fpm
exec php-fpm7.4 -F