FROM php:8.1-apache
ENV PORT=80

# Enable Apache modules
RUN a2enmod rewrite headers && a2dismod --force autoindex

# Set document root to /public
RUN mkdir /public /private \
 && chmod 0777 /public /private \
 && chown www-data:www-data /public /private \
 && sed -i "s|/var/www/|/public/|g" /etc/apache2/apache2.conf \
 && sed -i "s|/var/www/html|/public|g" /etc/apache2/sites-available/*.conf \
# Disable directory listing
 && sed -i "s|Options Indexes FollowSymLinks|Options FollowSymLinks|g" /etc/apache2/apache2.conf \
# Change port
 && sed -i "s|80|$\{PORT\}|" /etc/apache2/ports.conf /etc/apache2/sites-available/000-default.conf

# Use the default production configuration
RUN mv $PHP_INI_DIR/php.ini-production $PHP_INI_DIR/php.ini

# Disable Apache and PHP expose header
RUN sed -i "s/^ServerTokens OS/ServerTokens Prod/g" /etc/apache2/conf-available/security.conf \
 && sed -i "s/^ServerSignature On//g" /etc/apache2/conf-available/security.conf \
 && sed -i "s/^expose_php = On/expose_php = Off/g" $PHP_INI_DIR/php.ini
