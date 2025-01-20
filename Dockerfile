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
    nodejs \
    npm \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd pdo_mysql pdo_pgsql zip mbstring exif pcntl bcmath intl opcache

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Node.js (version 18 or higher)
RUN apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/v3.18/main/ nodejs>=18

# Copy the Laravel application files
COPY . .

# Install PHP dependencies
RUN composer install --optimize-autoloader --no-dev

# Install Node.js dependencies and build assets
RUN npm install && npm run build
RUN php artisan migrate:fresh
# Copy Nginx configuration
COPY docker/nginx.conf /etc/nginx/nginx.conf

# Copy Supervisor configuration
COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Create necessary log directories
RUN mkdir -p /var/log/php-fpm /var/log/nginx /var/log/supervisor

# Set permissions for Laravel storage and bootstrap cache
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Set environment variables
ENV APP_NAME="MERRIAM.shop"
ENV APP_ENV=local
ENV APP_KEY=base64:YAulFl6EgyphSFwXsd4lfu1gdiIGKfrP4Uxu/podKV4=
ENV APP_DEBUG=true
ENV APP_TIMEZONE=UTC
ENV APP_URL=http://44.230.95.183
ENV APP_LOCALE=en
ENV APP_FALLBACK_LOCALE=en
ENV APP_FAKER_LOCALE=en_US
ENV APP_MAINTENANCE_DRIVER=file
ENV PHP_CLI_SERVER_WORKERS=4
ENV BCRYPT_ROUNDS=12
ENV LOG_CHANNEL=stack
ENV LOG_STACK=single
ENV LOG_DEPRECATIONS_CHANNEL=null
ENV LOG_LEVEL=debug
ENV DB_CONNECTION=sqlite
ENV SESSION_DRIVER=database
ENV SESSION_LIFETIME=120
ENV SESSION_ENCRYPT=false
ENV SESSION_PATH=/
ENV SESSION_DOMAIN=null
ENV BROADCAST_CONNECTION=log
ENV FILESYSTEM_DISK=local
ENV QUEUE_CONNECTION=database
ENV CACHE_STORE=database
ENV CACHE_PREFIX=
ENV MEMCACHED_HOST=127.0.0.1
ENV REDIS_CLIENT=phpredis
ENV REDIS_HOST=127.0.0.1
ENV REDIS_PASSWORD=null
ENV REDIS_PORT=6379
ENV MAIL_MAILER=log
ENV MAIL_SCHEME=null
ENV MAIL_HOST=127.0.0.1
ENV MAIL_PORT=2525
ENV MAIL_USERNAME=null
ENV MAIL_PASSWORD=null
ENV MAIL_FROM_ADDRESS="hello@example.com"
ENV MAIL_FROM_NAME="${APP_NAME}"
ENV AWS_ACCESS_KEY_ID=
ENV AWS_SECRET_ACCESS_KEY=
ENV AWS_DEFAULT_REGION=us-east-1
ENV AWS_BUCKET=
ENV AWS_USE_PATH_STYLE_ENDPOINT=false
ENV VITE_APP_NAME="${APP_NAME}"

# Expose port 80 for Nginx
EXPOSE 80

# Start Supervisor to manage Nginx and PHP-FPM
CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
