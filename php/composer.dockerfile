FROM composer:2

ARG UID
ARG GID
ARG USER

ENV UID=${UID}
ENV GID=${GID}
ENV USER=${USER}

RUN delgroup dialout

RUN addgroup -g ${GID} --system ${USER}
RUN adduser -G ${USER} --system --disabled-password --shell /bin/sh -u ${UID} ${USER}

WORKDIR /var/www/html