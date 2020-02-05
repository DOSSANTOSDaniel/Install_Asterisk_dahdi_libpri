#!/bin/bash

#Déclaration des variables de couleur

vertclair='\e[1;32m'

orange='\e[0;33m'

jaune='\e[1;33m'

neutre='\e[0;m'

bleuclair='\e[1;34m'

rougefonce='\e[0;31m'

##################


echo -e "\n $orange ####################################################### $neutre \n"
echo -e " $bleuclair           script d'installation d'Asterisk           $neutre "
echo -e "\n $orange ####################################################### $neutre \n"

echo -e "\n $rougefonce@@@@@@@@@@@@@@@@@@@@@@@@@@$neutre \n"
echo -e " $vertclair Groupe B: Jovial;Daniel$neutre "
echo -e "\n $bleuclair@@@@@@@@@@@@@@@@@@@@@@@@@@$neutre \n"

if [ -d "/usr/src/asterisk" ]

then

echo "Le dossier asterisk existe déjà continuer!"

cd /usr/src/asterisk

	if [ -f "/usr/src/asterisk/asterisk-13-current.tar.gz" ]
	
	then
	
	echo "Le fichier d'installation existe déjà!"
	
	else
	
	#wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-13-current.tar.gz

	tar xzvf asterisk-13-current.tar.gz

	rm asterisk-13-current.tar.gz
	
	fi

ls --color

sleep 2

app="asterisk-13.14.0"

read -p " la version du dossier est asterisk-13.14.0 ?  [O][N] ===>" -n 1 dossier

if [ $dossier = "n" ] || [ $dossier = "N" ]

then

	read -p "Quelle est la nouvelle version ? ===>" app

	cd /usr/src/asterisk/$app 

fi

apt-get install build-essential

apt-get install openssl libxml2-dev libncurses5-dev linux-headers-`uname -r` libsqlite3-dev uuid-dev sqlite3 pkg-config libjansson-dev libssl-dev

bash /usr/src/asterisk/$app/configure

cd /usr/src/asterisk/$app/contrib/scripts

bash /usr/src/asterisk/$app/contrib/scripts/install_prereq install

bash /usr/src/asterisk/$app/configure

cd /usr/src/asterisk/$app/

make menuselect

make && make install

make samples

make config

#make install-logrotate

echo -e "\n $bleuclair TEST de l'installation' $neutre \n"

read -p "valider pour continuer"

/etc/init.d/asterisk status

sleep 6

echo ""

/etc/init.d/asterisk start

sleep 6

echo ""

/etc/init.d/asterisk status

sleep 6

echo ""

netstat -paunt | grep asterisk

sleep 6

echo ""

echo -e "\n $rougefonce FIN du test $neutre \n"

read -p "valider pour continuer"

#mettre une frase pour dire que nous allons sauvegarder les fichiers conf

echo -e "\n $rougefonce Sauvegarde des fichiers de configuration $neutre \n"

cd /etc/asterisk/

mkdir /etc/sauvegarde_conf_asterisk

cp -r /etc/asterisk/* /etc/sauvegarde_conf_asterisk

#mettre ici une condition if

if [ -d "/etc/sauvegarde_conf_asterisk" ]
	
	then
	
	echo "La sauvegarde s'est bien effectuée! dans `pwd`"
	
	read -p "valider pour continuer"
	
	else
	
	echo "Attention erreur de sauvegarde"
	
	read -p "valider pour continuer"
	
	fi

echo -e "\n $rougefonce Configuration de la langue $neutre \n"

sleep 2

echo -e "\n $rougefonce Editer le fichier ari.conf, mettre enable=no $neutre \n"

read -p "valider pour continuer"

nano ari.conf

echo -e "\n $rougefonce décommenter languageprefix=yes dans asterisk.conf $neutre \n"

read -p "valider pour continuer"

nano asterisk.conf

echo -e "\n $rougefonce décommenter language=fr dans sip.conf $neutre \n"

read -p "valider pour continuer"

nano sip.conf

echo -e "\n $rougefonce Rechargez les configurations d'asterisk avec la commande reload ! $neutre \n"

read -p "valider pour continuer"

asterisk -rvvvv

echo ""
	echo -e   "$orange *************************************** $neutre"
	echo -e   "$rougefonce *************************************** $neutre"
	echo -e   "$jaune * ######      ##       ####    ##     * $neutre"
	echo -e   "$vertclair * ##                   #####   ##     * $neutre"
	echo -e   "$orange * ######      ##       ##  ##  ##     * $neutre"
        echo -e   "$rougefonce * ##          ##       ##   ## ##     * $neutre"
        echo -e   "$bleuclair * ##          ##       ##    ####     * $neutre"
        echo -e   "$jaune * ##          ##       ##     ###     * $neutre"
        echo -e   "$rougefonce *************************************** $neutre"
        echo -e   "$orange *************************************** $neutre"

