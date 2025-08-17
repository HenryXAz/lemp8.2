FROM php:8.2-fpm-alpine

ARG UID
ARG GID
ARG USER

ENV UID=${UID}
ENV GID=${GID}
ENV USER=${USER}

RUN delgroup dialout

RUN addgroup -g ${GID} --system ${USER}
RUN adduser -G ${USER} --system --disabled-password --shell /bin/sh -u ${UID} ${USER}

RUN sed -i  "s/user = www-data/user = '${USER}'/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/group = www-data/group = '${USER}'/g" /usr/local/etc/php-fpm.d/www.conf
RUN echo "php_admin_flag[log_errors] = on " >> /usr/local/etc/php-fpm.d/www.conf



#RUN docker-php-ext-install pdo pdo_mysql bcmath

RUN apk --no-cache add postgresql-dev
RUN #apk add --no-cache curl openssl libpng-dev libjpeg-turbo-dev freetype-dev libzip-devunzip

RUN docker-php-ext-install pdo pdo_pgsql bcmath

RUN apk add --no-cache \
      freetype \
      libjpeg-turbo \
      libpng \
      freetype-dev \
      libjpeg-turbo-dev \
      libpng-dev \
    && docker-php-ext-configure gd \
      --with-freetype=/usr/include/ \
      # --with-png=/usr/include/ \ # No longer necessary as of 7.4; https://github.com/docker-library/php/pull/910#issuecomment-559383597
      --with-jpeg=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-enable gd \
    && apk del --no-cache \
      freetype-dev \
      libjpeg-turbo-dev \
      libpng-dev \
    && rm -rf /tmp/*

RUN mkdir -p /usr/src/php/ext/redis \
    && curl -fsSL https://github.com/phpredis/phpredis/archive/refs/tags/6.0.2.tar.gz| tar xvz -C /usr/src/php/ext/redis --strip 1 \
    && echo 'redis' >> /usr/src/php-available-exts \
    && docker-php-ext-install redis

CMD ["php-fpm", "-y", "/usr/local/etc/php-fpm.conf", "-R"]
