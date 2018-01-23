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
    vim \
    wget

COPY conf/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# install adminer.php
RUN mkdir /usr/share/adminer; \
    wget "http://www.adminer.org/latest.php" -O /usr/share/adminer/latest.php; \
    ln -s /usr/share/adminer/latest.php /usr/share/adminer/adminer.php; \
    echo "Alias /adminer.php /usr/share/adminer/adminer.php" | tee /etc/apache2/conf-available/adminer.conf; \
    a2enconf adminer.conf

RUN a2enconf php7.0-fpm; \
    a2enmod actions fastcgi alias proxy proxy_fcgi rewrite; \
    service php7.0-fpm start

EXPOSE 80

CMD ["/usr/bin/supervisord"]