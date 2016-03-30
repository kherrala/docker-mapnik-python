FROM ubuntu:16.04

MAINTAINER Kyosti Herrala <kyosti.herrala@gmail.com>

ENV MAPNIK_VERSION v3.0.10

RUN apt-get update && apt-get -y upgrade && apt-get -y --no-install-recommends install \
    curl nginx openssl ca-certificates supervisor rsyslog \
    libboost-python-dev libmapnik-dev mapnik-utils \
    python-nose python-cairo-dev python-setuptools python-gevent python-pip python-gdal python-pil python-cairo

# Mapnik Python bindings
RUN touch /usr/include/mapnik/warning_ignore.hpp && \
    cd /tmp/ && curl -sL https://github.com/mapnik/python-mapnik/archive/master.tar.gz | tar xz && \
    cd /tmp/python-mapnik-master && PYCAIRO=true python setup.py install
