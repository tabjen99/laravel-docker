FROM php:7.4-apache

# Install unzip utility and libs needed by zip PHP extension 
RUN apt-get update && apt-get install -y \
    zlib1g-dev \
    libzip-dev \
    unzip
RUN docker-php-ext-install zip

COPY . /var/www/html
RUN ls -la .
# 1. Install development packages and clean up apt cache.
RUN apt-get update && apt-get install -y 
   # curl \
 RUN apt-get update && apt-get install -y g++ 
    RUN apt-get update && apt-get install -y  git 
    RUN apt-get update && apt-get install -y  libbz2-dev 
    RUN apt-get update && apt-get install -y  libfreetype6-dev 
    RUN apt-get update && apt-get install -y  libicu-dev 
    RUN apt-get update && apt-get install -y  libjpeg-dev 
    RUN apt-get update && apt-get install -y  libmcrypt-dev 
    RUN apt-get update && apt-get install -y  libpng-dev 
    RUN apt-get update && apt-get install -y  libreadline-dev 
    RUN apt-get update && apt-get install -y  sudo \
    #RUN apt-get update && apt-get install -y  unzip \
    #zip \
 && rm -rf /var/lib/apt/lists/*

# 2. Apache configs + document root.
RUN echo "ServerName laravel-app.local" >> /etc/apache2/apache2.conf

ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# 3. mod_rewrite for URL rewrite and mod_headers for .htaccess extra headers like Access-Control-Allow-Origin-
RUN a2enmod rewrite headers

# 4. Start with base PHP config, then add extensions.
#RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"


    RUN docker-php-ext-install bcmath 
    RUN docker-php-ext-install bz2 
    RUN docker-php-ext-install calendar 
    RUN docker-php-ext-install iconv 
    RUN docker-php-ext-install intl 
    RUN docker-php-ext-install opcache 
    RUN docker-php-ext-install pdo_mysql 
    #RUN docker-php-ext-install zip 

#install some base extensions
#RUN apt-get install -y zip libzip-dev \
#&& docker-php-ext-configure zip --with-libzip 
  


# 5. Composer.
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 6. We need a user with the same UID/GID as the host user
# so when we execute CLI commands, all the host file's permissions and ownership remain intact.
# Otherwise commands from inside the container would create root-owned files and directories.
ARG uid
RUN useradd -G www-data,root -u 1000 -d /home/devuser devuser
RUN mkdir -p /home/devuser/.composer && \
    chown -R devuser:devuser /home/devuser

#set folder permission
RUN set -ex && \
	chown -R www-data:www-data /var/www/html && \
	chown -R www-data:www-data /var/www && \
	mkdir -p /var/www/html/storage/logs && \
	touch /var/www/html/storage/logs/laravel.log && \
	chown -R www-data:www-data /var/www/html/storage

RUN composer self-update 1.10.7
RUN ls -la
RUN composer dump-autoload --no-scripts
#run composer install
RUN set -ex; \
	composer install \
		--no-dev \
	--optimize-autoloader \
		--classmap-authoritative \
		--ignore-platform-reqs \
		--working-dir=/var/www/html

#COPY ./docker-entrypoint.sh /
#RUN ["chmod", "+x", "/docker-entrypoint.sh"]
#ENTRYPOINT ["sh","/docker-entrypoint.sh"]

#
VOLUME /var/www/html
#
#RUN php artisan migrate
#
#EXPOSE 8080 80 443