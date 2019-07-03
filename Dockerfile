FROM ubuntu:18.04
LABEL maintainer="George Draghici <george@geohost.ro>"

# Setting frontend Noninteractive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Avoid ERROR: invoke-rc.d: policy-rc.d denied execution of start.
RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d

# Install supervisor, mysql-client, php-fpm, composer
RUN apt-get update ; \
    apt-get install -y \
    software-properties-common

RUN add-apt-repository ppa:ondrej/php

RUN apt-get update ; \
    apt-get install -y \
    apt-utils \
    wget \
    nano \
    curl \
    unzip \
    php7.0-redis \
    php7.0-cli \
    php7.0-fpm \
    php7.0-bz2 \
    php7.0-bcmath \
    php7.0-curl \
    php7.0-gd \
    php7.0-json \
    php7.0-mbstring \
    php7.0-mcrypt \
    php7.0-xml \
    php7.0-xmlrpc \
    php7.0-zip \
    php7.0-opcache \
    php7.0-cgi \
    php7.0-xml \
    php7.0-mysql \
    php7.0-sqlite3 \
    php7.0-imagick \
    libmysqlclient-dev \
    mysql-client \
    imagemagick \
    mailutils \
    net-tools \
    supervisor

# Install PHP ionCube module
ADD modules/ioncube_loader_lin_7.0.so /usr/lib/php/20180731/
#RUN apt install php-dev libmcrypt-dev gcc make autoconf libc-dev pkg-config -y
#RUN yes "" | pecl install mcrypt-1.0.1
#RUN echo "extension=mcrypt.so" | tee -a /etc/php/7.0/fpm/conf.d/mcrypt.ini

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


# Copy php.ini file
ADD conf/php/php.ini /etc/php/7.0/fpm/php.ini
RUN mkdir -p /var/log/php
RUN touch /var/log/php/php-error.log && chown -R www-data:www-data /var/log/php

#Create docroot directory , copy code and Grant Permission to docroot
RUN mkdir -p /app
RUN chown -R www-data:www-data /app

ADD conf/php/www.conf /etc/php/7.0/fpm/pool.d/www.conf
ADD conf/supervisord.conf /etc/supervisor/supervisord.conf


# Enable www-data user shell
RUN chsh -s /bin/bash www-data

EXPOSE 9000

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

CMD ["/docker-entrypoint.sh"]
