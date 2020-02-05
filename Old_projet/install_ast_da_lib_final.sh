#!/bin/bash

# TITRE: Installation interactive d'Asterisk 13
#================================================================#
# DESCRIPTION:
#  Ce script va nous permettre d'installer et de configurer
#  Asterisk 13 de manière simplifiée.
#================================================================#
# AUTEURS:
#  Daniel DOS SANTOS < danielitto91@gmail.com >
#================================================================#
# USAGE: ./install_asterisk_V1.sh
#================================================================#
# NOTES:
# 
#================================================================#


# Variables de chemins
dire="/usr/src/asterisk"

#___LES FONCTIONS___
function verif_ip
        {
        ip="$(ifconfig eth0 | grep 'inet adr:' | cut -d: -f2 | awk '{ print $1}')"
        echo -e "     << IP du serveur Asterisk ==> [ $ip ] >> \n"
        }
        
function cowsay
        {
        clear
        echo -e "\n $1 \n"
        }
        
function teste0
        {
	echo -e "\n TEST installation \n"
	read -p "Valider pour continuer"

	#permet de voir le statut d'asterisk s'il est activé ou désactivé
	/etc/init.d/asterisk status

	#fait une pause de 2 secondes
	sleep 2
	echo ""

	#permet de démarrer le serveur Asterisk
	/etc/init.d/asterisk start
	sleep 2
	echo ""
	/etc/init.d/asterisk status
	sleep 2
	echo ""

	#netstat netstat (network statistics), est une commande qui affiche des informations sur les connexions réseau
	#option -p affiche les informations concernant les protocoles
	#option -a affiche l'ensemble des connexions et des ports en écoute sur la machine.
	#option -u udp
	#option -n Affiche les connexions TCP actives.
	#option -t tcp
	#grep asterisk trie pour afficher seulement les lignes en relation avec asterisk
	port=`netstat -paunt | grep asterisk`

	echo "$port"
	sleep 2
	echo ""
	echo -e "\n FIN du test \n"
	}

function sauvegarde
    {
    echo -e "\n Sauvegarde des fichiers de configuration \n"
    cd /etc/asterisk/

    #création d'un dossier qui va sauvegarder tous les fichiers de configuration d'asterisk
    mkdir /etc/sauvegarde_conf_asterisk

    #cp -r copie de dossier/fichiers récursivement
    cp -r /etc/asterisk/* /etc/sauvegarde_conf_asterisk

    #test pour vérifier la création de la sauvegarde
    if [ -d "/etc/sauvegarde_conf_asterisk" ]
    then

        echo -e "\n La sauvegarde s'est bien effectuée! dans /etc/sauvegarde_conf_asterisk \n"
        read -p "valider pour continuer"

    else

        echo "\n Attention erreur sauvegarde non effectuée! \n"
        read -p "valider pour continuer"

    fi
    }

function question
    {
    #Dans une mise à jour de la version 12 d’Asterisk, ARI a été ajouté.
    #contrôler l’état d’une boîte de réception par des systèmes externes et peut entrée en conflit avec une configuration basique.
    echo -e "\n Dé-commenter languageprefix=yes dans asterisk.conf ligne 30 \n"
    read -p "Valider pour continuer"
    nano -c /etc/asterisk/asterisk.conf
    sleep 2

    echo -e "\n ligne 115 : remplacer public par default \n"
    read -p "Valider pour continuer"
    nano -c /etc/asterisk/sip.conf
    sleep 2

    echo -e "\n Rechargez les configurations d'asterisk avec la commande reload et exit pour quitter! \n"
    read -p "valider pour continuer"
    asterisk -rvvvv
    sleep 2
    }

clear
echo -e "\n Script d'installation d'Asterisk \n"

echo -e "\n Installation par les dépôts Debian ou par compilation des sources ?"
read -p "Dépôs[d], Compilation[c] ==> " -n 1 net
echo ""
           
#__Installation de paquets et mises à jours utiles pour la globalité du scripte.
apt-get install netstat -y
apt-get update && apt-get upgrade -y
apt-get install linux-headers-$(uname -r) -y

if [ $net = "d" ] || [ $net = "D" ]
then

echo -e "\n INSTALLATION ASTERISK V.13 PAR LES DEPOTS DEBIAN JESSIE 8.10 \n"

#Préparation à l’environnement d'installation d'Asterisk, installation de dépendances.
apt-get install libpri-dev -y
apt-get install libpri1.4 -y
apt-get install asterisk-dahdi -y
apt-get install dahdi-linux -y
apt-get install dahdi-source -y
apt-get install dahdi -y
apt-get install dahdi-firmware-nonfree -y
apt-get install asterisk -y
apt-get install asterisk-config -y
apt-get install asterisk-core-sounds-fr -y
apt-get install asterisk-core-sounds-fr-g722 -y
apt-get install asterisk-core-sounds-fr-gsm -y
apt-get install asterisk-core-sounds-fr-wav -y
apt-get install asterisk-dev -y
apt-get install asterisk-doc -y
apt-get install asterisk-modules -y
apt-get install asterisk-mp3 -y
apt-get install asterisk-mysql -y
apt-get install asterisk-ooh323 -y
apt-get install asterisk-prompt-fr-armelle -y
apt-get install asterisk-prompt-fr-proformatique -y
apt-get install asterisk-voicemail -y
apt-get install asterisk-voicemail-imapstorage -y
apt-get install asterisk-voicemail-odbcstorage -y
apt-get install dahdi-firmware-nonfree -y

teste0

read -p "valider pour continuer"

sauvegarde

cowsay "Configuration interactive"

sleep 3

question

service asterisk stop
sleep 1
service asterisk start

info_compt
verif_ip

read -p "valider pour terminer l'installation"
    echo ""
    fin
	exit 3
else
	echo -e "\n $rougefonce Installation par compilation en cours !$neutre \n"
fi

echo ""

ban "   INSTALLATION ASTERISK V.13    " "PAR COMPILATION SUR DEBIAN 8.10"

sleep 5
#Préparation à l’environnement d'installation d'Asterisk, installation de dépendances.
sleep 3
apt-get install libxml2-dev -y
apt-get install git-core -y
apt-get install uuid -y
apt-get install uuid-dev -y
apt-get install sqlite3 -y
apt-get install libsqlite3-dev -y
apt-get install ncurses-dev -y
apt-get install mpg123 -y
apt-get install build-essential -y
apt-get install gcc -y
apt-get install g++ -y
apt-get install libjansson-dev -y
apt-get install automake -y
apt-get install autoconf -y
apt-get install libtool -y
apt-get install make -y
apt-get install libncurses5-dev -y
apt-get install patch -y
apt-get install libtool -y

#test sur les dossiers nécessaires a l'installation.
#Test si le dossier Asterisk était déjà créé
if [ -d "/usr/src/asterisk" ]

then

	echo -e "\n Le dossier asterisk existe déjà continuer! \n"

	cd $dire

else

	echo -e "\n Création du dossier asterisk! \n"

	mkdir $dire

	cd $dire

#Test de la création du dossier asterisk
	if [ -d $dire ]

	then

		echo -e "\n Le dossier a bien été crée: `pwd` \n"
		read -p "valider pour continuer"

	else

		echo -e "\n Attention erreur de la création du dossier asterisk \n"

#exit1 stop immédiatement le script
		exit 1

	fi
fi

#test de présence d'un dossier dans le dossier asterisk
test -d $dire/*

#$? prend les valeurs 0=présent 1=absent
if [ $? = 0 ]

then

	echo -e "\n $rougefonce Attention un ou plusieurs fichiers sont présent! $neutre \n"
	echo ""
	ls --color
	echo ""
	read -p "quitter[] ou nettoyer[n] ! ==> " -n 1 net

	echo ""
	if [ $net = "n" ] || [ $net = "N" ]

	then

		rm -rf $dire/*
		echo -e "\n $rougefonce Suppression OK, téléchargement en cours $neutre \n"

	else

		exit 2

	fi

else

	echo ""

	echo -e "\n $rougefonce Téléchargement en cours $neutre \n"

	echo ""

fi

#DHADI
sleep 5

cowsay "Installation de DAHDI"

sleep 3
#Téléchargement de DAHDI
cd $dire
git clone git://git.asterisk.org/dahdi/linux dahdi-linux
git clone git://git.asterisk.org/dahdi/tools dahdi-tools
cd $dire/dahdi-linux
make install
cd dahdi-tools
autoreconf -i
./configure
make install

#libpri
sleep 6

cowsay "Installation de LIBPRI"

sleep 3

#Téléchargement de libpri
cd $dire
wget http://downloads.asterisk.org/pub/telephony/libpri/libpri-current.tar.gz

#tar commande permettant de décompresser la librairie libpri
tar xvzf libpri-current.tar.gz
sleep 2
rm -rf libpri-current.tar.gz
#compilation de la librairie libpri
cd libpri-*
make
make install
cd $dire

#Asterisk
sleep 2

cowsay "Installation d'ASTERISK"

sleep 3

#Téléchargement d'Asterisk 13

#wget commande permettant de télécharger un fichier distant
wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-13-current.tar.gz

#tar commande permettant de décompresser
tar xzvf asterisk-13-current.tar.gz

#rm asterisk-13-current.tar.gz
rm -rf asterisk-13-current.tar.gz
app=$(ls | grep asterisk*)

cd $dire/$app

#make distclean Commande qui permet de faire un peu le ménage et évite des erreurs
make distclean

#commande qui vérifier que toutes les dépendances sont présentes
#ensuite configure et écrit un fichier Makefile qui contiendra les ordres de compilation
./configure

read -p "Valider pour continuer"

cd $dire/$app/contrib/scripts

#Encore des dépendances
./install_prereq install

read -p "Valider pour continuer"

cd $dire/$app/

./configure

read -p "Valider pour continuer"

#menuselect est une manière facile de configurer Asterisk en mode semi graphique

clear
echo -e "Dans le menuselect configurez comme sur le tableau !"
echo -e "----------------------------------------------------\n"
echo -e "\n-------------------------------------------------
|      Core sound packages     |                |
-------------------------------- Wav, Ulaw, alaw|
| Musique on hold file packages|                |
-------------------------------- Gsm, G729, G722|
|      Extras sound packages   |                |
-------------------------------------------------\n"

sleep 2
read -p "Validez pour continuer" 
make menuselect

#La commande make fait une série de commandes, située dans un fichier appelé Makefile qui va s’occuper des dépendances entre autre
make

read -p "Valider pour continuer"

#Cette commande invoque à nouveau make, qui recherche la cible installe dans le Makefile
#et suit les instructions pour installer le programme.
make install

read -p "Valider pour continuer"

#installe les exemples de configuration possibles !
make samples

#installe la documentation
make progdocs

#installer le script d'initialisation ou initscript.
#Ce script démarre Asterisk lorsque votre serveur démarre,
#surveillera le processus Asterisk au cas où quelque chose de mauvais lui arriver,
#et peut être utilisé pour arrêter ou redémarrer Asterisk ainsi. Pour installer l'initscript, utilisez la commande make config.
make config

#À mesure que votre système Asterisk s'exécute,
#il générera des fichiers journaux.
#Il est recommandé d'installer le script de logrotation
# afin de compresser et de faire pivoter ces fichiers, d'économiser de l'espace disque et de les rechercher
#ou de les cataloguer plus facilement. Pour ce faire, utilisez la commande make install-logrotate.
make install-logrotate

teste0

read -p "valider pour continuer"

sauvegarde

sleep 3

cowsay "configuration interactive"

sleep 3

echo -e "\n $rougefonce Editer le fichier ari.conf, mettre enable=no à la ligne 2 $neutre \n"
read -p "valider pour continuer"
nano -c ari.conf
sleep 2
echo ""
question

sleep 3

cowsay "configuration basique des comptes"

sleep 2

echo '[general]
hasvoicemail = yes
hassip = yes

[template_users](!)
type = friend
host = dynamic
dtmfmode = rfc2833
disallow = all
allow = ulaw
allow = alaw
allow = gsm
secret = kcx

[1101](template_users)
fullname = daniel DOS SANTOS
username = daniel
callerid = "daniel" <1101>
mailbox = 1101
context = finance

[1102](template_users)
fullname = jovial Ndongui
username = jovial
callerid = "jovial" <1102>
mailbox = 1102
context = finance' > /etc/asterisk/users.conf
sleep 2

echo '[general]
static = yes
writeprotect = yes
autofallthrough=yes
clearglobalvars = yes

[finance]
exten => _11XX, 1, DIAL(SIP/${EXTEN},20)
exten => _11XX, 2, Voicemail(${EXTEN}@finance)

exten => 666, 1, Answer()
exten => 666, 2, VoiceMailMain(${CALLERID(num)}@finance)

exten => 111, 1, answer
exten => 111, 2, Playback(demo-echotest)
exten => 111, 3, Echo()' > /etc/asterisk/extensions.conf
sleep 2

echo '[general]
maxmsg = 100
maxsecs = 0
minsecs = 0
maxlogins = 3
review = yes
saycid = yes

[finance]
1101 => 1234, daniel
1102 => 1234, jovial' > /etc/asterisk/voicemail.conf

service asterisk stop
sleep 1
service asterisk start

sleep 2
info_compt
verif_ip

read -p "valider pour terminer l'installation"
fin
