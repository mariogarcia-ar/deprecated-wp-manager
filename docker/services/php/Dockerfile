FROM php:7.4-fpm-alpine

# Install dependencies
RUN docker-php-ext-install mysqli pdo pdo_mysql && docker-php-ext-enable mysqli pdo pdo_mysql 

RUN chown www-data:www-data /var/www/html -R && chmod 755 /var/www/html -R

RUN echo "<?php echo 'My docker LAMP'; " > /var/www/html/index.php
