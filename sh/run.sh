#!/bin/bash

[[ -f /apache.env ]] && . /apache.env

for file in /run/apache2/apache2.pid ${APACHE_PID_FILE}
do
    [[ -f $file ]] && {
        /bin/rm -f $file && echo "Found $file. Deleted." 
    }
done

/usr/sbin/apache2 -f /etc/apache2/apache2.conf -e info -DFOREGROUND
