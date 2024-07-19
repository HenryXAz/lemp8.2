FROM nginx:stable-alpine

ARG UID
ARG GID
ARG USER

ENV UID=${UID}
ENV GID=${GID}
ENV USER=${USER}

# Dialot group in alpine conflicts with MacOS
RUN delgroup dialout

# Create user and group

RUN addgroup -g ${GID} --system ${USER}
RUN adduser -G ${USER} --system --disabled-password --shell /bin/sh -u ${UID}  ${USER}

# modify nginx conf to use new user's priviledges for starting it
RUN sed -i "s/user nginx/user '${USER}'/g" /etc/nginx/nginx.conf

# Copy all nginx configuration to override default
ADD ./*.conf /etc/nginx/conf.d/

# Make html directory
RUN mkdir -p /var/www/html/app
RUN mkdir -p /var/www/html/pma