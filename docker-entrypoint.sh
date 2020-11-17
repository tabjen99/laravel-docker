

php artisan key:generate
#RUN php artisan migrate
php artisan make:auth --force

php artisan config:cache

#php artisan vendor:publish --all#

##touch /var/www/html/storage/logs/laravel.log
#chown -R www-data:www-data /var/www/html/storage
#chown -R www-data:www-data /var/www/html/storage/logs

#php artisan migrate --force