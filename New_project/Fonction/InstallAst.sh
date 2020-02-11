#!/bin/bash

set -e

CountryCode="33"

apt update && apt full-upgrade -y
apt install wget -y
apt install gpg -y
apt install vim -y
apt install dialog -y
apt install apt-utils -y
apt install systemd -y

wget https://downloads.asterisk.org/pub/telephony/asterisk/releases/asterisk-16.7.0.tar.gz -O /usr/local/src/asterisk-16.7.0.tar.gz
wget https://downloads.asterisk.org/pub/telephony/asterisk/releases/asterisk-16.7.0.sha256 -O /usr/local/src/asterisk-16.7.0.sha256
wget https://downloads.asterisk.org/pub/telephony/asterisk/releases/asterisk-16.7.0.tar.gz.asc -O /usr/local/src/asterisk-16.7.0.tar.gz.asc

cd /usr/local/src/
sha256sum -c /usr/local/src/asterisk-16.7.0.sha256
gpg --keyserver 'hkp://keyserver.ubuntu.com' --recv-keys '5D984BE337191CE7'
gpg --verify /usr/local/src/asterisk-16.7.0.tar.gz.asc /usr/local/src/asterisk-16.7.0.tar.gz

tar xzvf /usr/local/src/asterisk-16.7.0.tar.gz
echo "libvpb1 libvpb1/countrycode select $CountryCode" | debconf-set-selections
yes | bash /usr/local/src/asterisk-16.7.0/contrib/scripts/install_prereq install
cd /usr/local/src/asterisk-16.7.0/
./configure

make menuselect.makeopts
/usr/local/src/asterisk-16.7.0/menuselect/menuselect --enable-category MENUSELECT_ADDONS menuselect.makeopts
/usr/local/src/asterisk-16.7.0/menuselect/menuselect --disable CORE-SOUNDS-EN-GSM menuselect.makeopts
/usr/local/src/asterisk-16.7.0/menuselect/menuselect --enable CORE-SOUNDS-FR-WAV menuselect.makeopts
/usr/local/src/asterisk-16.7.0/menuselect/menuselect --enable CORE-SOUNDS-FR-ULAW menuselect.makeopts
/usr/local/src/asterisk-16.7.0/menuselect/menuselect --enable CORE-SOUNDS-FR-ALAW menuselect.makeopts
/usr/local/src/asterisk-16.7.0/menuselect/menuselect --enable MOH-OPSOUND-ULAW menuselect.makeopts
/usr/local/src/asterisk-16.7.0/menuselect/menuselect --enable MOH-OPSOUND-ALAW menuselect.makeopts 
/usr/local/src/asterisk-16.7.0/menuselect/menuselect --enable EXTRA-SOUNDS-FR-WAV menuselect.makeopts
/usr/local/src/asterisk-16.7.0/menuselect/menuselect --enable EXTRA-SOUNDS-FR-ULAW menuselect.makeopts
/usr/local/src/asterisk-16.7.0/menuselect/menuselect --enable EXTRA-SOUNDS-FR-ALAW menuselect.makeopts

contrib/scripts/get_mp3_source.sh
make
make install
make samples
make config
ldconfig

groupadd asterisk
useradd -r -d /var/lib/asterisk -g asterisk asterisk
usermod -aG audio,dialout asterisk
chown -R asterisk.asterisk /etc/asterisk
chown -R asterisk.asterisk /var/{lib,log,spool}/asterisk
chown -R asterisk.asterisk /usr/lib/asterisk
