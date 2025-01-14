# Dockerfile
FROM php:8.3-fpm

ENV BUILD_DEPS \
        libpng-dev \
        libjpeg-dev \
        libfreetype6-dev \
        libonig-dev \
        libzip-dev \
        libpq-dev \
        unzip \
        zip \
        curl \
        nginx

# 安裝系統依賴和 PHP 擴展
RUN apt-get update && \
    apt-get install -y \
        ${BUILD_DEPS} \
    && \
        docker-php-ext-configure gd --with-freetype --with-jpeg \
    && \
        docker-php-ext-install \
            gd \
            mbstring \
            zip \
            pdo \
            pdo_mysql \
            pdo_pgsql \
            opcache \
            mysqli \
            bcmath

# 安裝 WordPress CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# 複製 PHP 設定
COPY ./php/php.ini /usr/local/etc/php/

# 設置工作目錄
WORKDIR /var/www/html

COPY ./.docker/entrypoint.sh /entrypoint.sh

# 設置權限
RUN chown -R www-data:www-data /var/www/html

EXPOSE 9000

RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

CMD ["php-fpm"]
