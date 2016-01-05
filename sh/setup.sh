#!/bin/bash

SVC_FQDN=${SVC_FQDN:-localhost}
SVC_PORT=${SVC_PORT:-80}
SVC_DB_INSTANCE=${SVC_DB_INSTANCE:-soplanning}
SVC_DB_USERNAME=${SVC_DB_USERNAME:-root}
SVC_DB_PASSWORD=${SVC_DB_PASSWORD:-root}
SVC_DB_TYPE=${SVC_DB_TYPE:-mysql}

sed -i "s/Listen 80/Listen ${SVC_FQDN}:${SVC_PORT}/" /etc/apache2/apache2.conf
sed -i "s@ErrorLog.*@ErrorLog /var/log/apache2/apache.err@" /etc/apache2/apache2.conf
sed -i "s@CustomLog.*@CustomLog /var/log/apache2/apache.log combined@" /etc/apache2/apache2.conf

[[ ! -f /.database.inc.setup.is.done ]] && {
    sed -i "/cfgHostname/ s/localhost/${SVC_FQDN}/" /opt/trunk/database.inc
    sed -i "/cfgDatabase/ s/soplanning/${SVC_DB_INSTANCE}/" /opt/trunk/database.inc
    sed -i "/cfgUsername/ s/root/${SVC_DB_USERNAME}/" /opt/trunk/database.inc
    sed -i "/cfgPassword/ s/root/${SVC_DB_PASSWORD}/" /opt/trunk/database.inc
    sed -i "/cfgSqlType/ s/mysql/${SVC_DB_TYPE}/" /opt/trunk/database.inc

    touch /.database.inc.setup.is.done
}

exit 0
