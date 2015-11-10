FROM debian:jessie
MAINTAINER Domen Ipavec <domen@ipavec.net>

# do installs and cleanup in one step to save on space
# apt update
RUN apt-get -y update \
 && apt-get -y upgrade \

# apt installs
&& apt-get -y --force-yes install memcached \
 libcairo2 \
 libcairo2-dev \
 libmysqlclient-dev \
 build-essential \
 python \
 libpython2.7 \
 python-dev \
 python-pip \
 python-cairo \
 python-rrdtool \
 supervisor \

# pip installs
&& pip install uwsgi \
 python-memcached \
 mysqlclient \
 django \
 django-tagging \
 pytz \
 https://github.com/graphite-project/ceres/tarball/master \
 whisper \
 carbon \
 graphite-web \

# deinstall unneeded stuff
&& apt-get -y remove build-essential python-dev libcairo-dev libmysqlclient-dev python-pip \
 && apt-get -y autoremove \

# cleanup
&& apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY init.sh /usr/bin/init.sh

RUN cp -r /opt/graphite/conf /opt/graphite/conf-example

EXPOSE 8000

CMD ["/usr/bin/init.sh"]
