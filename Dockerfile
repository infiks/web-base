FROM php:8.1-apache
ENV PORT=80

# Enable Apache modules
RUN a2enmod rewrite headers && a2dismod --force autoindex

# Set document root to /public
RUN mkdir /public /private \
 && chmod 0777 /public /private \
 && chown www-data:www-data /public /private \
 && sed -i "s|80|$\{PORT\}\nServerName localhost|" /etc/apache2/ports.conf

WORKDIR /public

# Use the default production configuration
RUN mv $PHP_INI_DIR/php.ini-production $PHP_INI_DIR/php.ini

# Disable Apache and PHP expose header
RUN sed -i "s/^ServerTokens OS/ServerTokens Prod/g" /etc/apache2/conf-available/security.conf \
 && sed -i "s/^ServerSignature On//g" /etc/apache2/conf-available/security.conf \
 && sed -i "s/^expose_php = On/expose_php = Off/g" $PHP_INI_DIR/php.ini

# Copy virtual host configuration
COPY default.conf /etc/apache2/sites-available/000-default.conf

# Enable health checks
COPY CHECKS ./
RUN echo Healthy > /var/www/healthy && chown www-data:www-data /var/www/healthy
