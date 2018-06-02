FROM ubuntu:16.04
MAINTAINER Salmon Erasmus <sjerasmus@gmail.com>

# Install dependencies
RUN apt-get update -y && \
        apt-get install -y \
        apache2 \
        unzip \
        curl \
        vim \
        php7.0 \
        php7.0-cli \
        libapache2-mod-php7.0 \
        php7.0-gd \
        php7.0-json \
        php7.0-ldap \
        php7.0-mbstring \
        php7.0-mysql \
        php7.0-pgsql \
        php7.0-mcrypt \
        php7.0-sqlite3 \
        php7.0-xml \
        php7.0-xsl \
        php7.0-zip \
        php7.0-soap \
        mysql-client \
        php7.0-curl \
        php7.0-zip \
        mcrypt && \
        curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN apt-get update && apt-get install -y sudo && rm -rf /var/lib/apt/lists/*

# Add the application files to the image
RUN mkdir -p /var/www/web-app

# Configure apache
RUN a2enmod rewrite
RUN a2enmod ssl
RUN chown -R www-data:www-data /var/www/web-app
RUN chmod g+s /var/www/web-app

ENV APACHE_DOCUMENTROOT=/var/www/web-app/public
ENV APACHE_RUN_USER www-data
ENV APACHE_SERVERNAME=localhost
ENV APACHE_SERVERADMIN=admin@localhost
ENV APACHE_RUN_USER=www-data
ENV APACHE_RUN_GROUP=www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE=/var/run/apache2.pid
ENV APACHE_RUN_DIR=/var/run/apache2
ENV APACHE_LOCK_DIR=/var/lock/apache2

EXPOSE 80 443

WORKDIR /var/www/web-app

# Define default command.
CMD /usr/sbin/apache2 -D FOREGROUND