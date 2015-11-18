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

if [ ! -f /opt/graphite/conf/local_settings.py ]; then
    cp /opt/graphite/webapp/graphite/local_settings.py.example /opt/graphite/conf/local_settings.py

    # generate secret key
    sed -i -e "s/#SECRET_KEY = 'UNSAFE_DEFAULT'/SECRET_KEY = '$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)'/g" /opt/graphite/conf/local_settings.py

    # setup database
    sed -i "1i import os" /opt/graphite/conf/local_settings.py
    sed -i -e "s/#DATABASES = {/DATABASES = {/g" /opt/graphite/conf/local_settings.py
    sed -i -e "s/#    'default': {/    'default': {/g" /opt/graphite/conf/local_settings.py
    sed -i -e "s/#        'NAME': '\/opt\/graphite\/storage\/graphite.db',/        'NAME': 'graphite',/g" /opt/graphite/conf/local_settings.py
    sed -i -e "s/#        'ENGINE': 'django.db.backends.sqlite3',/        'ENGINE': 'django.db.backends.mysql',/g" /opt/graphite/conf/local_settings.py
    sed -i -e "s/#        'USER': '',/        'USER': 'graphite',/g" /opt/graphite/conf/local_settings.py
    sed -i -e "s/#        'PASSWORD': '',/        'PASSWORD': 'graphite',/g" /opt/graphite/conf/local_settings.py
    sed -i -e "s/#        'HOST': '',/        'HOST': os.environ['MYSQL_PORT_3306_TCP_ADDR'],/g" /opt/graphite/conf/local_settings.py
    sed -i -e "s/#        'PORT': ''/        'PORT': '3306'/g" /opt/graphite/conf/local_settings.py
    sed -i -e "s/#    }/    }/g" /opt/graphite/conf/local_settings.py
    sed -i -e "s/#}/}/g" /opt/graphite/conf/local_settings.py
fi

if [ ! -f /opt/graphite/webapp/graphite/local_settings.py ]; then
    ln -s /opt/graphite/conf/local_settings.py /opt/graphite/webapp/graphite/local_settings.py
fi

python /opt/graphite/webapp/graphite/manage.py migrate auth
python /opt/graphite/webapp/graphite/manage.py migrate

/usr/bin/supervisord
