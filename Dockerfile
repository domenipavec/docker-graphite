FROM python:2

RUN apt-get -y update\
 && apt-get -y upgrade

RUN apt-get -y --force-yes install memcached \
 libcairo2 \
 libcairo2-dev \
 python-cairo \
 python-rrdtool

RUN pip install uwsgi \
 python-memcached \
 mysqlclient \
 django \
 django-tagging \
 pytz \
 https://github.com/graphite-project/ceres/tarball/master \
 whisper \
 carbon \
 graphite-web

# cleanup
RUN apt-get clean\
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/sbin/my_init"]
