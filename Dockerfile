FROM ubuntu:20.04

# MSYS 2020
ENV ITDEVGROUP_TIME_ZONE America/Argentina/Buenos_Aires

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    nginx \
    mysql-server \
    php7.4 \
    supervisor

##  php7.4 extensiones
RUN apt-get update -yqq \
    && apt-get install -yqq \
	php7.4-bcmath \
	php-ctype \
	php7.4-ldap \
	php7.4-json \
	php7.4-mbstring \
	php-xml \
	php7.4-zip  \
	openssl \
	php-tokenizer \
	php7.4-pdo \
	php7.4-pdo-mysql \
	php7.4-mysql \
	php7.4-cli \
	php7.4-gd  \
	php7.4-opcache \
	php7.4-common \
	php7.4-intl \
	php7.4-xsl \
	php7.4-imap \	
	php7.4-curl \
    php7.4-zip  \
    php7.4-fpm \
	php-memcached \
    && apt-get install -y pkg-config \
    && apt-get install -y -q --no-install-recommends \
    ssmtp

# Timezone por defecto
RUN echo "date.timezone=$ITDEVGROUP_TIME_ZONE" > /etc/php/7.4/cli/conf.d/timezone.ini

RUN apt-get install -y nano

# msyql configuración
COPY /docker/mysql/my.cnf   /etc/mysql/my.cnf
COPY /docker/mysql/init_db.sql /etc/mysql/init_db.sql
COPY /docker/mysql/initdb.sh   /etc/mysql/initdb.sh
COPY /docker/mysql/createdb.sh   /etc/mysql/createdb.sh

RUN chmod 0444 /etc/mysql/my.cnf
RUN chmod +x /etc/mysql/initdb.sh

# COPY . /
COPY /docker/nginx/nginx.conf   /docker/nginx/nginx.conf
COPY /docker/nginx/default.conf /docker/nginx/default.conf
COPY /docker/nginx/server.conf /docker/nginx/server.conf
COPY /docker/php/php.ini   /docker/php/php.ini
COPY /docker/php/www.conf   /docker/php/www.conf
COPY /docker/supervisor/supervisor.conf   /docker/supervisor/supervisor.conf



# creamos y copiamos el resto de la configuración
RUN mkdir -p /var/tmp/nginx \
    && mkdir app \
    && mkdir /etc/nginx/conf.d/server \
    && mkdir -p /var/log/supervisor \
    && mkdir -p /etc/nginx/conf.d \
    && mkdir -p /etc/php7/php-fpm.d \
	&& cp -rf /docker/nginx/server.conf  /etc/nginx/conf.d/server \
    && cp -rf /docker/nginx/nginx.conf  /etc/nginx/nginx.conf \
    && cp -rf /docker/nginx/default.conf                /etc/nginx/conf.d/default.conf \
    && cp -rf /docker/php/php.ini                       /etc/php7/php.ini \
    && cp -rf /docker/php/www.conf                      /etc/php7/php-fpm.d/www.conf \
    && cp -rf /docker/supervisor/supervisor.conf        /etc/supervisord.conf 

ADD --chown=www-data:www-data www /app/
COPY www /app/

RUN chmod a+rwx -R /app/wp-config.php
RUN chmod a+rwx -R /app/wp-content

WORKDIR /app

# portal
EXPOSE 80

# persistencia "/etc/nginx/conf.d/server",
VOLUME ["/var/lib/mysql","/wp-content"]

CMD [ "/etc/mysql/createdb.sh" ]