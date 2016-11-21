FROM php:5.6-apache

MAINTAINER <admin@opensvc.com>

RUN apt-get update && apt-get -y upgrade && DEBIAN_FRONTEND=noninteractive apt-get -y install unzip vim libdbd-mysql php5-mysqlnd php5-gd

RUN DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confnew" install libapache2-mod-php5 && apt-get clean

ADD soplanning-1-38.zip /tmp

RUN cd /opt && unzip /tmp/soplanning-1-38.zip && rmdir /var/www/html && ln -s /opt/soplanning/www /var/www/html && chown -Rh www-data:www-data /opt/soplanning && rm -f /tmp/soplanning-1-38.zip

RUN sed -i 's/0000-00-00/1111-11-11/g' /opt/soplanning/sql/planning_mysql.sql

ADD sh/setup.sh /
ADD sh/run.sh /
RUN chmod +x /setup.sh /run.sh
ADD Dockerfile /
RUN cp /usr/share/php5/php.ini-production /usr/local/etc/php.ini

CMD /setup.sh && /run.sh
