FROM debian:bullseye

# Set up WordPress directory
WORKDIR /var/www/html

# installing required packages
RUN apt-get update -y && apt-get install -y \
    php7.4-fpm \
    php7.4-mysql \
    curl \
    mariadb-client \
    net-tools \
    && rm -rf /var/lib/apt/lists/* \
    && curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# copying php-fpm configuration
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/
RUN chmod 644 /etc/php/7.4/fpm/pool.d/www.conf

# copying initialization script
COPY tools/init.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init.sh

EXPOSE 9000

CMD ["/usr/local/bin/init.sh"]