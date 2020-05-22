FROM ubuntu:16.04

RUN apt-get update && \
    apt-get install -y software-properties-common python-software-properties && \
    LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php && \
    apt-get update && \
    apt-get install -y \
    supervisor \
    apache2 \
    php7.2-fpm \
    php7.2-mbstring \
    php7.2-xml \
    php7.2-mysql \
    php7.2-gd \
    php7.2-curl \
    php7.2-sqlite3 \
    php-redis \
    php-mongodb \
    libapache2-mod-fastcgi \
    unzip \
    vim \
    wget \
    git

COPY conf/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# install adminer.php
RUN mkdir /usr/share/adminer; \
    wget "http://www.adminer.org/latest.php" -O /usr/share/adminer/latest.php; \
    ln -s /usr/share/adminer/latest.php /usr/share/adminer/adminer.php; \
    echo "Alias /adminer.php /usr/share/adminer/adminer.php" | tee /etc/apache2/conf-available/adminer.conf; \
    a2enconf adminer.conf

# install composer
RUN php -r "readfile('https://getcomposer.org/installer');" | php -- --filename=composer --install-dir=/usr/local/bin/

RUN a2enconf php7.2-fpm; \
    a2enmod actions fastcgi alias proxy proxy_fcgi rewrite; \
    service php7.2-fpm start

EXPOSE 80

CMD ["/usr/bin/supervisord"]