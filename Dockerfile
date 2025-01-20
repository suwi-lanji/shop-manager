# Use the official PHP image with FPM and Alpine Linux as the base image
FROM php:8.2-fpm-alpine

# Set working directory
WORKDIR /var/www/html

# Install system dependencies
RUN apk add --no-cache \
    nginx \
    supervisor \
    curl \
    git \
    unzip \
    libzip-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    oniguruma-dev \
    libxml2-dev \
    icu-dev \
    postgresql-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd pdo_mysql pdo_pgsql zip mbstring exif pcntl bcmath intl opcache

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy the Laravel application files
COPY . .

# Install PHP dependencies
RUN composer install --optimize-autoloader --no-dev
RUN npm install
RUN npm run build
# Copy Nginx configuration
COPY docker/nginx.conf /etc/nginx/nginx.conf

# Copy Supervisor configuration
COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Set permissions for Laravel storage and bootstrap cache
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Expose port 80 for Nginx
EXPOSE 80

# Start Supervisor to manage Nginx and PHP-FPM
CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
