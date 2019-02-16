#!/bin/bash

# Firewall Asterisk
# iptables -A INPUT -p udp --dport 5060 -j ACCEPT
# iptables -A OUTPUT -p udp --dport 5060 -j ACCEPT

# Installation Asterisk
echo Telechargement des paquets Asterisk
sleep 2
apt-get -y install build-essential
sleep 1
apt-get -y install libxml2-dev
sleep 1
apt-get -y install libncurses5-dev
sleep 1
apt-get -y install linux-headers-2.6.26-2-amd64
sleep 1
apt-get -y install libsqlite3-dev
sleep 1
echo Installation des paquets terminee
sleep 1

dirAste=/usr/src/asterisk
asteVer=asterisk-1.8.31.1
mkdir $dirAste
cd $dirAste
cp /home/root/disk/$asteVer.tar.gz .
tar zxvf $asteVer.tar.gz
cd $asteVer
./configure
make menuselect
make
make install
make samples
make config

/etc/init.d/asterisk restart

echo Configurer asterisk ? y / n
read reponse
if  [ $reponse = "y" ] || [ $reponse = "o" ] || [ $reponse = "O" ] || [ $reponse = "Y" ] || [ $reponse = "yes" ]
	echo Configuration du trunk SIP ? y / n
	read reponse
	if  [ $reponse = "y" ] || [ $reponse = "o" ] || [ $reponse = "O" ] || [ $reponse = "Y" ] || [ $reponse = "yes" ]
		echo Entrer le serveur d enregistrement, serveur fournisseur d acces
		read serveurTrunk
		echo Entrer le compte client 
		read compteTrunk
		echo Entrer le mot de passe client
		read passTrunk
	fi
	echo Configuration des comptes SIP ? y / n
	if  [ $reponse = "y" ] || [ $reponse = "o" ] || [ $reponse = "O" ] || [ $reponse = "Y" ] || [ $reponse = "yes" ]
		echo Entrer le nombre de compte SIP a creer
		read nbCompte
		
	fi
	asterisk -rx "sip reload"
fi
echo Fin de la configuration asterisk

exit 0
# Fin Asterisk
