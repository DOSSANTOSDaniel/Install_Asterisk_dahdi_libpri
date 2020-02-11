#!/bin/bash
set -e

wget https://downloads.asterisk.org/pub/telephony/libpri/releases/libpri-1.6.0.sha256 -O /usr/local/src/libpri-1.6.0.sha256
wget https://downloads.asterisk.org/pub/telephony/libpri/releases/libpri-1.6.0.tar.gz -O /usr/local/src/libpri-1.6.0.tar.gz

cd /usr/local/src/
sha256sum -c libpri-1.6.0.sha256

tar xzvf /usr/local/src/libpri-1.6.0.tar.gz

cd /usr/local/src/libpri-1.6.0
make
make install
