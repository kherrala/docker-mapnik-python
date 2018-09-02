FROM ubuntu:18.04

MAINTAINER Kyosti Herrala <kyosti.herrala@gmail.com>

ENV MAPNIK_VERSION v3.0.19

RUN apt-get update && apt-get -y upgrade && apt-get install \
    curl openssl ca-certificates build-essential libboost-python-dev libmapnik-dev mapnik-utils \
    python-nose python-cairo-dev python-setuptools python-gdal python-pil python-cairo \
    -y --no-install-recommends && rm -rf /var/lib/apt/lists/*

# Mapnik Python bindings
RUN cd /tmp/ && curl -sL https://github.com/mapnik/python-mapnik/archive/v3.0.x.tar.gz | tar -xz && \
    cd /tmp/python-mapnik-3.0.x/ && PYCAIRO=true python setup.py install
