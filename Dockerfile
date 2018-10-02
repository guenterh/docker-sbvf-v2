FROM nimmis/apache

MAINTAINER nimmis <kjell.havneskold@gmail.com>
MAINTAINER guenterh <guenter.hipler@unibas.ch>


# disable interactive functions
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
apt-get install -y wget less vim  graphviz locales ssh rsync git \
php libapache2-mod-php  \
php-fpm php-cli php-mysqlnd php-pgsql php-sqlite3 php-redis \
php-apcu php-intl php-imagick php-mcrypt php-json php-gd php-curl mcrypt \
php-bcmath php-bz2 php-common php-dba php-dev \
php-mbstring php-mysql php-opcache \
php-readline php-soap php-xml php-zip php-xdebug && \
phpenmod mcrypt && a2enmod rewrite
RUN rm -rf /var/lib/apt/lists/* && \
cd /tmp && curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer && \
mkdir -p /usr/local/vufind/httpd/public && unlink /etc/apache2/sites-enabled/000-default.conf 
COPY files/devlocal.swissbib.ch.conf /etc/apache2/sites-available 
RUN cd /etc/apache2/sites-enabled && ln -s ../sites-available/devlocal.swissbib.ch.conf
RUN useradd -ms /bin/bash vufind
#USER vufind
COPY vufind /usr/local/vufind/httpd
WORKDIR /usr/local/vufind/httpd

RUN chown -R vufind:vufind . && service apache2 start
#USER vufind
#RUN composer install
#USER root






