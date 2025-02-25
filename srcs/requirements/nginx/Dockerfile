FROM debian:bullseye

ARG DOMAIN_NAME

# installing nginx and ssl tools
RUN apt-get update -y && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /etc/nginx/ssl

# generating ssl certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/inception.key \
    -out /etc/nginx/ssl/inception.crt \
    -subj "/C=DE/ST=Baden-Württemberg/L=Heilbronn/O=42/OU=42/CN=dhasan.42.fr/UID=dhasan"

# copying nginx config
COPY conf/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]