# Dockerfile
FROM php:8.2-apache

# Copy custom Apache configuration

# Install additional tools and development dependencies
RUN apt-get update \
    && apt-get install -y git bash curl unzip \
                          libzip-dev libonig-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install PHP extensions including pdo_mysql
RUN docker-php-ext-install pdo_mysql

#upload
RUN echo "file_uploads = On\n" \
         "memory_limit = 1024M\n" \
         "upload_max_filesize = 500M\n" \
         "post_max_size = 500M\n" \
         "max_execution_time = 600\n" \
         > /usr/local/etc/php/conf.d/uploads.ini

# Config apache
COPY apache.conf /etc/apache2/sites-available/000-default.conf

# Set the working directory
WORKDIR /var/www/html

# Expose port 8080
EXPOSE 8080

# CMD to start Apache
CMD ["apache2-foreground"]