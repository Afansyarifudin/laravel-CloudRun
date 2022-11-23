FROM php:8.1-fpm-alpine 

RUN apk add --no-cache nginx wget 

RUN mkdir -p /run/nginx

COPY docker/nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /app 

COPY . /app
COPY ./src /app

RUN sh -c "wget http://getcomposer.org/composer.phar && chmod a+x composer.phar && mv composer.phar /usr/local/bin/composer"
RUN cd /app && \
    /usr/local/bin/composer install --no-dev

RUN chown -R www-data: /app

RUN chmod -R 775 /app
RUN chmod -R 775 /app/vendor
RUN chmod -R 777 /app/storage

CMD sh /app/docker/startup.sh