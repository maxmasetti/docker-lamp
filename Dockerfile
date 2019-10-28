FROM php:apache

RUN docker-php-ext-install mysqli 
RUN docker-php-ext-install pdo_mysql
