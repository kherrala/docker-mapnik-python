FROM debian:jessie

MAINTAINER Kyosti Herrala <kyosti.herrala@gmail.com>

ENV MAPNIK_VERSION v3.0.5

# Essential stuffs
RUN apt-get update && apt-get install -y \
    build-essential autoconf libtool software-properties-common python-software-properties curl

# Boost
RUN apt-get install -y libboost-dev libboost-filesystem-dev libboost-program-options-dev libboost-python-dev \
    libboost-regex-dev libboost-system-dev libboost-thread-dev

# Mapnik dependencies
RUN apt-get install -y --no-install-recommends \
    libbz2-dev libxml2-dev \
    libjpeg-dev libtiff-dev libpng12-dev \
    libgdal1-dev libproj-dev libharfbuzz-dev libsqlite3-dev \
    libicu-dev libfreetype6-dev \
    libcairo2 libcairo2-dev libcairomm-1.0-dev \
    ttf-unifont ttf-dejavu ttf-dejavu-core ttf-dejavu-extra \
    python-dev python-gdal python-nose python-cairo python-cairo-dev

# Mapnik
RUN curl -s https://mapnik.s3.amazonaws.com/dist/$MAPNIK_VERSION/mapnik-$MAPNIK_VERSION.tar.bz2 | tar -xj -C /tmp/ && \
    cd /tmp/mapnik-$MAPNIK_VERSION && \
    python scons/scons.py configure JOBS=4 INPUT_PLUGINS=all OPTIMIZATION=3 SYSTEM_FONTS=/usr/share/fonts/truetype/ && \
    make && make install JOBS=4 && ldconfig

# Mapnik Python bindings
RUN apt-get install python-setuptools && touch /usr/local/include/mapnik/warning_ignore.hpp
RUN cd /tmp/ && curl -sL https://github.com/mapnik/python-mapnik/archive/master.tar.gz | tar xz
RUN cd /tmp/python-mapnik-master && PYCAIRO=true python setup.py install

# Cleanup
RUN rm -r /tmp/mapnik-$MAPNIK_VERSION \
    && rm -r /tmp/python-mapnik-master \
    && apt-get autoremove -y --purge build-essential \
    && rm -rf /var/lib/apt/lists/*
