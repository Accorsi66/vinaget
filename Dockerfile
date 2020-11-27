FROM php:5.6-apache

COPY . /var/www/html

RUN apt-get update && \
    apt-get install -y python-pip libnet1 libnet1-dev libpcap0.8 libpcap0.8-dev libmcrypt-dev wget zip unzip apache2-utils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY ./ports.conf /etc/apache2/ports.conf

RUN docker-php-ext-install mcrypt && \
    docker-php-ext-install mbstring && \
    a2enmod rewrite && \
    chmod 777 -R /var/www/html/data && \
    chmod 666 /var/www/html/data/account.dat && \
    chmod 666 /var/www/html/data/config.dat && \
    chmod 666 /var/www/html/data/cookie.dat && \
    chmod 666 /var/www/html/data/online.dat && \
    chmod 666 /var/www/html/data/log.txt && \
    chmod 666 /var/www/html/data/datafile_descrypt.html

RUN chown -R www-data:www-data /var/www/ && \
    service apache2 restart

ENV PORT 8080

CMD sed -i "s/80/$PORT/g" /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf && docker-php-entrypoint apache2-foreground
