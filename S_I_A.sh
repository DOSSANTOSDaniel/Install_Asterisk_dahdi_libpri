#!/bin/bash
#
#Script permetant l'automatisation de l'installation d'un serveur de VoIP (Asterisk)
#
#Déclaration des variables de couleur
vertclair='\e[1;32m'

orange='\e[0;33m'

jaune='\e[1;33m'

neutre='\e[0;m'

bleuclair='\e[1;34m'

rougefonce='\e[0;31m'

#Ici l'option -e permet la prise en compte des couleurs'
echo -e "\n $orange ####################################################### $neutre \n"
echo -e " $bleuclair           #__SCRIPT INSTALLATION ASTERISK__#           $neutre "
echo -e "\n $orange ####################################################### $neutre \n"

#Test si le dossier asterisk étais déjà crée
if [ -d "/usr/src/asterisk" ]

then

	echo "Le dossier asterisk existe déjà continuer!"

	cd /usr/src/asterisk

else

	echo "Création du dossier asterisk!"

	mkdir /usr/src/asterisk

	cd /usr/src/asterisk
	
#Test de la création du dossier asterisk
	if [ -d "/usr/src/asterisk" ]
	
	then
	
		echo "Le dossier a bien été crée: `pwd`"
	
		read -p "valider pour continuer"
	
	else
	
		echo "Attention erreur de la création du dossier asterisk"
		
#exit1 stop imediatement le script
		exit 1
	
	fi
fi	

#test de presence d'un dossier dans le dossier asterisk
test -d /usr/src/asterisk/*

#$? prend les valeurs 0=present 1=abcsent
present=$?

if [ $present = 0 ]

then

	echo -e "$rougefonce Attention un fichier est présent! $neutre"

	ls --color

	read -p "quitter[] ou nettoyer[n] !" -n 1 net

	if [ $net = "n" ] || [ $net = "N" ]
	
	then
		
		rm -rf *
		
		echo ""

		echo -e "$rougefonce Téléchargement en cours $neutre"

		echo ""
		
	else
	
		exit 2
		
	fi
	
else
	
	echo ""

	echo -e "$rougefonce Téléchargement en cours $neutre"

	echo ""
	
fi

#wget commande permettant de télécharger un fichier distant
wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-13-current.tar.gz

#tar commande permettant de decompresser
tar xzvf asterisk-13-current.tar.gz

rm asterisk-13-current.tar.gz

app=`ls`
	
cd /usr/src/asterisk/$app 

#mise à jour du système
apt-get update && apt-get upgrade -y

#installer les dépendances nécéssaires à la compilation d’Asterisk.
apt-get install build-essential -y

#installer les dépendances nécéssaires à la compilation d’Asterisk.
apt-get install openssl libxml2-dev libncurses5-dev linux-headers-`uname -r` libsqlite3-dev uuid-dev sqlite3 libjansson-dev libssl-dev -y

#make distclean Commande qui permet de faire un peu le ménage et évite des erreurs
make distclean

#commande qui vérifier que toutes les dépendances sont présentes
#ensuite configure et écrit un fichier Makefile qui contiendra les ordres de compilation
./configure

read -p "Valider pour continuer"

cd /usr/src/asterisk/$app/contrib/scripts

#Encore des dependances 
./install_prereq install

read -p "Valider pour continuer"

cd /usr/src/asterisk/$app/

./configure

read -p "Valider pour continuer"

#menuselect est une manière facile de configurer Asterisk en mode semi graphique 
make menuselect

#La commande make fait une série de commandes, située dans un fichier appelé Makefile qui va s'ocuper des dependances entre autre
make 

read -p "Valider pour continuer"

#Cette commande invoque à nouveau make, qui recherche la cible install dans le Makefile 
#et suit les instructions pour installer le programme.
make install

read -p "Valider pour continuer"

#installe les exemples de configuration possibles !
make samples

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

echo -e "\n $bleuclair TEST installation $neutre \n"

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

echo -e "\n $rougefonce FIN du test $neutre \n"

read -p "valider pour continuer"

echo -e "\n $rougefonce Sauvegarde des fichiers de configuration $neutre \n"

cd /etc/asterisk/

#création d'un dossier qui va saugarder tous les fichiers de configuration d'asterisk
mkdir /etc/sauvegarde_conf_asterisk

#cp -r copie de dossier/fichiers recursivement
cp -r /etc/asterisk/* /etc/sauvegarde_conf_asterisk

#test pour verifier la création de la sauvegarde
if [ -d "/etc/sauvegarde_conf_asterisk" ]
	
then
	
	echo "La sauvegarde s'est bien effectuée! dans /etc/sauvegarde_conf_asterisk"
	
	read -p "valider pour continuer"
	
else
	
	echo "Attention erreur sauvegarde non effectuée!"
	
	read -p "valider pour continuer"
	
fi

echo -e "\n $rougefonce Configurations générales $neutre "
echo -e " $jaune --------------------------------------- $neutre \n"
#Dans une mise à jour de la version 12 d’Asterisk, ARI a été ajouté.
#contrôler l’état d’une boîte de réception par des systèmes externes et peut entrée en comflit avec une configuration basique
echo -e "\n $rougefonce Editer le fichier ari.conf, mettre enable=no à la ligne 2 $neutre \n"

read -p "valider pour continuer"

nano -c ari.conf

echo -e "\n $rougefonce Décommenter languageprefix=yes dans asterisk.conf ligne 30 $neutre \n"

read -p "Valider pour continuer"

nano -c asterisk.conf

echo -e "\n $rougefonce Décommenter language=en puis modifier en language=fr dans sip.conf ligne 344 $neutre \n"

read -p "Valider pour continuer"

nano -c sip.conf

echo -e "\n $rougefonce Rechargez les configurations d'asterisk avec la commande reload et exit pour quitter! $neutre \n"

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

