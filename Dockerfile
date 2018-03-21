FROM webdevops/php-apache-dev:5.6
MAINTAINER ed.mizurov@notebook.com

RUN apt update && apt install -y libpq-dev \
 libgearman-dev \
  libgeoip-dev npm && docker-php-ext-install pdo pdo_pgsql pgsql && pecl install geoip
RUN npm install -g bower
RUN ln -s /usr/bin/nodejs /usr/bin/node
RUN curl https://pecl.php.net/get/gearman-1.1.2.tgz -o /tmp/gearman-1.1.2.tgz
RUN cd /tmp; tar -xzvf gearman-1.1.2.tgz && cd gearman-1.1.2 && phpize && ./configure && make && make install   
RUN mv /tmp/gearman-1.1.2/modules/gearman.so /usr/local/lib/php/extensions/no-debug-non-zts-20131226/
RUN echo "extension=gearman.so" > /usr/local/etc/php/conf.d/gearman.ini && echo "extension=geoip.so" > /usr/local/etc/php/conf.d/geoip.ini
RUN mkdir /usr/share/GeoIP &&  curl http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz -o /tmp/GeoLiteCity.dat.gz 
RUN curl http://download.maxmind.com/download/geoip/database/asnum/GeoIPASNum.dat.gz -o /tmp/GeoIPASNum.dat.gz
RUN cd /tmp; ls -la &&  gunzip /tmp/GeoLiteCity.dat.gz && ls -la &&  mv /tmp/GeoLiteCity.dat /usr/share/GeoIP/GeoIPCity.dat && gunzip GeoIPASNum.dat.gz && mv -v GeoIPASNum.dat /usr/share/GeoIP/GeoIPASNum.dat