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

RUN chown -R vufind:vufind . 
#USER vufind
#RUN composer install
#USER root


[Sun Sep 30 20:30:57.634005 2018] [:error] [pid 59] [client 172.17.0.1:39034] PHP Fatal error:  Uncaught Zend\\Config\\Exception\\RuntimeException: File '/usr/local/vufind/httpd/local/classic/local/config/vufind/./../../../../private_config_values/private_config_classic_local_database.conf' doesn't exist or not readable in /usr/local/vufind/httpd/vendor/zendframework/zend-config/src/Reader/Ini.php:66\nStack trace:\n#0 /usr/local/vufind/httpd/vendor/zendframework/zend-config/src/Reader/Ini.php(218): Zend\\Config\\Reader\\Ini->fromFile('/usr/local/vufi...')\n#1 /usr/local/vufind/httpd/vendor/zendframework/zend-config/src/Reader/Ini.php(176): Zend\\Config\\Reader\\Ini->processKey('@include', './../../../../p...', Array)\n#2 /usr/local/vufind/httpd/vendor/zendframework/zend-config/src/Reader/Ini.php(134): Zend\\Config\\Reader\\Ini->processSection(Array)\n#3 /usr/local/vufind/httpd/vendor/zendframework/zend-config/src/Reader/Ini.php(86): Zend\\Config\\Reader\\Ini->process(Array)\n#4 /usr/local/vufind/httpd/module/VuFind/src/VuFind/Config/PluginFactory.php(87): Zend\\Config\\Reader\\Ini->fromFile('/usr/local/vufi...')\n#5 /usr/local/ in /usr/local/vufind/httpd/vendor/zendframework/zend-servicemanager/src/Exception/ServiceLocatorUsageException.php on line 34




