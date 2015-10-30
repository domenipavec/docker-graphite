#!/bin/bash

if [ ! -f /opt/graphite/conf/carbon.conf ]; then
    cp /opt/graphite/conf-example/carbon.conf.example /opt/graphite/conf/carbon.conf
fi

if [ ! -f /opt/graphite/conf/storage-schemas.conf ]; then
    cp /opt/graphite/conf-example/storage-schemas.conf.example /opt/graphite/conf/storage-schemas.conf
fi

if [ ! -f /opt/graphite/conf/storage-aggregation.conf ]; then
    cp /opt/graphite/conf-example/storage-aggregation.conf.example /opt/graphite/conf/storage-aggregation.conf
fi

if [ ! -f /opt/graphite/conf/graphite.wsgi ]; then
    cp /opt/graphite/conf-example/graphite.wsgi.example /opt/graphite/conf/graphite.wsgi
fi

/usr/bin/supervisord
