FROM ubuntu:16.04

RUN apt-get update; \
    apt-get install -y \
    supervisor \
    apache2 \
    php7.0-fpm \
    php7.0-curl \
    php7.0-mcrypt \
    php7.0-mbstring \
    php7.0-mysql \
    php7.0-xml \
    php7.0-gd \
    php-redis \
    php-mongodb \
    libapache2-mod-fastcgi \
    unzip \
    vim; \
    php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/local/bin/ --filename=composer

COPY conf/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN a2enconf php7.0-fpm; \
    a2enmod actions fastcgi alias proxy proxy_fcgi rewrite; \
    service php7.0-fpm start

EXPOSE 80

CMD ["/usr/bin/supervisord"]