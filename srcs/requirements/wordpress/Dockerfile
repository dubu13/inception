FROM debian:bullseye

# installing required packages
RUN apt-get update -y && apt-get install -y \
    php7.4-fpm \
    php7.4-mysql \
    wget \
    curl \
    mariadb-client \
    net-tools \
    && rm -rf /var/lib/apt/lists/*

# creating directory for php-fpm socket
RUN mkdir -p /run/php

# downloading and installing wordpress

WORKDIR /var/www/html
RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz && \
    rm latest.tar.gz && \
    rm -f /var/www/html/wordpress/wp-config*.php && \
    chown -R www-data:www-data /var/www/html

# copying php-fpm configuration
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/
RUN chmod 644 /etc/php/7.4/fpm/pool.d/www.conf

# copying initialization script
COPY tools/init.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init.sh

EXPOSE 9000

CMD ["/usr/local/bin/init.sh"]