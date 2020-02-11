#!/bin/bash
set -e
apt-get install linux-headers-$(uname -r)
wget https://downloads.asterisk.org/pub/telephony/dahdi-linux-complete/releases/dahdi-linux-complete-3.1.0+3.1.0.tar.gz -O /usr/local/src/dahdi-linux-complete-3.1.0+3.1.0.tar.gz
wget https://downloads.asterisk.org/pub/telephony/dahdi-linux-complete/releases/dahdi-linux-complete-3.1.0+3.1.0.tar.gz.sha1 -O /usr/local/src/dahdi-linux-complete-3.1.0+3.1.0.tar.gz.sha1

cd /usr/local/src/
sha1sum -c dahdi-linux-complete-3.1.0+3.1.0.tar.gz.sha1 >> info.txt

tar xzvf /usr/local/src/dahdi-linux-complete-3.1.0+3.1.0.tar.gz
cd /usr/local/src/dahdi-linux-complete-3.1.0+3.1.0/ 
make
make install
make config
