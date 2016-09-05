#!/bin/bash

SVC_FQDN=${SVC_FQDN:-localhost}
SVC_PORT=${SVC_PORT:-80}
SVC_DB_INSTANCE=${SVC_DB_INSTANCE:-soplanning}
SVC_DB_USERNAME=${SVC_DB_USERNAME:-root}
SVC_DB_PASSWORD=${SVC_DB_PASSWORD:-root}
SVC_DB_TYPE=${SVC_DB_TYPE:-mysql}

cat > /apache.env <<EOF
export APACHE_LOCK_DIR=${APACHE_LOCK_DIR:-/var/lock/apache2}
export APACHE_PID_FILE=${APACHE_PID_FILE:-/var/run/apache2/apache2.pid}
export APACHE_RUN_USER=${APACHE_RUN_USER:-www-data}
export APACHE_RUN_GROUP=${APACHE_RUN_GROUP:-www-data}
export APACHE_LOG_DIR=${APACHE_LOG_DIR:-/var/log/apache2}
EOF

. /apache.env

sed -i "s/Listen 80/Listen ${SVC_FQDN}:${SVC_PORT}/" /etc/apache2/apache2.conf
sed -i "s@ErrorLog.*@ErrorLog ${APACHE_LOG_DIR}/apache.err@" /etc/apache2/apache2.conf
sed -i "s@CustomLog.*@CustomLog ${APACHE_LOG_DIR}/apache.log combined@" /etc/apache2/apache2.conf
sed -i "s/Listen 80/Listen ${SVC_FQDN}:${SVC_PORT}/" /etc/apache2/apache2.conf

[[ ! -f /.database.inc.setup.is.done ]] && {
    sed -i "/cfgHostname/ s/localhost/${SVC_FQDN}/" /opt/soplanning/database.inc
    sed -i "/cfgDatabase/ s/soplanning/${SVC_DB_INSTANCE}/" /opt/soplanning/database.inc
    sed -i "/cfgUsername/ s/root/${SVC_DB_USERNAME}/" /opt/soplanning/database.inc
    sed -i "/cfgPassword/ s/root/${SVC_DB_PASSWORD}/" /opt/soplanning/database.inc
    sed -i "/cfgSqlType/ s/mysql/${SVC_DB_TYPE}/" /opt/soplanning/database.inc

    touch /.database.inc.setup.is.done
}

exit 0
