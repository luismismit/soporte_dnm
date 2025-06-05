FROM php:8.2-apache

RUN apt-get update && apt-get install -y git unzip libzip-dev zip libpng-dev libonig-dev libxml2-dev curl \
    && docker-php-ext-install pdo pdo_mysql zip

RUN a2enmod rewrite

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY . /var/www/html

RUN composer install --no-interaction --prefer-dist --optimize-autoloader

RUN mkdir -p /var/www/html/storage && \
    chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html/storage

WORKDIR /var/www/html

EXPOSE 80

CMD php artisan migrate --force && apache2-foreground
