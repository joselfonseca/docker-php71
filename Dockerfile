FROM ubuntu:16.04

MAINTAINER Jose Fonseca <jose@ditecnologia.com>

RUN apt-get clean && apt-get -y update && apt-get install -y locales && locale-gen en_US.UTF-8
ENV LANG='en_US.UTF-8' LANGUAGE='en_US.UTF-8' LC_ALL='en_US.UTF-8'

RUN apt-get update \
    && apt-get install -y curl zip unzip git software-properties-common supervisor sqlite3 libxrender1 libxext6 mysql-client \
    && add-apt-repository -y ppa:ondrej/php \
    && apt-get update \
    && apt-get install -y php7.1-fpm php7.1-cli php7.1-gd php7.1-mysql \
       php7.1-imap php-memcached php7.1-mbstring php7.1-xml php7.1-curl \
       php7.1-sqlite3 php7.1-zip php7.1-pdo-dblib php7.1-bcmath php7.1-gmp \
    && php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer \
    && mkdir /run/php

RUN update-ca-certificates;

RUN curl -sL https://deb.nodesource.com/setup_10.x -o nodesource_setup.sh

RUN sh nodesource_setup.sh

RUN apt-get install -y nodejs build-essential

RUN curl -fsSL https://get.docker.com -o get-docker.sh

RUN sh get-docker.sh

RUN apt-get remove -y --purge software-properties-common \
	&& apt-get -y autoremove \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY php-fpm.conf /etc/php/7.1/fpm/php-fpm.conf

COPY www.conf /etc/php/7.1/fpm/pool.d/www.conf

EXPOSE 9000

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord"]