#!/bin/bash

# TITRE: Installation d'Asterisk 16
#================================================================#
# DESCRIPTION:
#  Ce script va nous permettre d'installer et de configurer
#  Asterisk 16.
#================================================================#
# AUTEURS:
#  Daniel DOS SANTOS < danielitto91@gmail.com >
#================================================================#
# USAGE: ./install_asterisk_V1.sh
#================================================================#
# NOTES:
# 
#================================================================#

### Variables ###
declare -r VerAst='asterisk-16.7.0'
declare -r KeyGpgAst='0x5D984BE337191CE7'
#Déclaration des variables de couleur
declare -r Green='\e[1;32m'
declare -r Orange='\e[0;33m'
declare -r Neutral='\e[0;m'
declare -r Blue='\e[1;34m'
declare -r Red='\e[0;31m'
#Récupération IP
declare -r ip_check="$(hostname -i | awk '{print $1}')"
#Téléchargements
declare -r DownloadDahdi="https://downloads.asterisk.org/pub/telephony/dahdi-linux-complete/releases/"
declare -r DownloadLibpri="https://downloads.asterisk.org/pub/telephony/libpri/releases/"
declare -r DownloadAsterisk="http://downloads.asterisk.org/pub/telephony/asterisk/releases/"

### Fonctions ###
function FailMes {
  echo -e "\n ${Red} ### ${1} ### ${Neutral} \n"
}

function InfoMes {
  echo -e "\n ${Green} ### ${1} ### ${Neutral} \n"
}

# Quand il y un exit, on efface les ressources que nous avons utilisées 
function Finish {
  for ErrExit in 'tar.gz.asc' 'sha256' 'tar.gz'
  do
    rm -rf "/usr/local/src/${VerAst}.${ErrExit}"
  done
}

function ExistInstall {
	Inx="$(dpkg -s ${1} | grep Status | awk '{print $2}')"

	if [ "${Inx}" == "install" ]
	then
		FailMes "Attention ${1} est déjà installé"
    exit 9
	else 
    type -a "${1}"
    if [ "${?}" == "0" ]
	  then
		  FailMes "Attention ${1} est déjà installé"
      exit 9
	  else
      test -d "/usr/local/src/${VerAst}"
      if [ "${?}" == "0" ]
	    then
		    FailMes "Attention ${1} est déjà présent sur /usr/local/src/${VerAst}"
        exit 9
	    else
		    InfoMes "Ok ${1} n'est pas installé sur cette machine !"
      fi
    fi    
	fi
}

function DownloadFile {

  for FileEx in 'tar.gz.asc' 'sha256' 'tar.gz'
  do
    wget -c -t 3 --progress=bar -O "/usr/local/src/${VerAst}.${FileEx}" "http://downloads.asterisk.org/pub/telephony/asterisk/releases/${VerAst}.${FileEx}" && sleep 1
    if [ ${?} == 0 ]
    then
        InfoMes "Le téléchargement du fichier ${VerAst}.${FileEx} est terminé !"
    else
        FailMes "Erreur de téléchargement du fichier ${VerAst}.${FileEx} !"
        exit 0
    fi
  done
}



function TestAuthen {
  InfoMes "Test sha256sum :"
  cd /usr/local/src/
  sha256sum -c "/usr/local/src/${VerAst}.sha256"
  if [ ${?} == 0 ]
  then
    InfoMes "vérification de la somme de contrôle SHA256 OK !"
  else
    FailMes "Erreur sur la vérification de la somme de contrôle SHA256 du fichier ${VerAst}.tar.gz !"
    exit 1
  fi
  InfoMes "Test GPG :"
  gpg2 --keyserver 'hkp://keyserver.ubuntu.com' --recv-keys "${KeyGpgAst}"
  gpg2 --verify "/usr/local/src/${VerAst}.tar.gz.asc" "/usr/local/src/${VerAst}.tar.gz"
  if [ ${?} == 0 ]
  then
    InfoMes "vérification de la clé GPG OK !"
  else
    FailMes "Erreur de vérification de la clé GPG du fichier ${VerAst}.tar.gz !"
    exit 2
  fi
}

function ExtractFile {
  tar xzvf "/usr/local/src/${VerAst}.tar.gz"
  if [ ${?} == 0 ]
  then
    InfoMes "Décompression OK !"
  else
    FailMes "Erreur de décompression du fichier ${VerAst}.tar.gz !"
    exit 3
  fi
}

### Code ###
clear

echo -e "\n ${Orange} ####################################################### ${Neutral} \n"
echo -e " ${Blue}     Installation et configuration d'Asterisk 16        ${Neutral} "
echo -e "\n ${Orange} ####################################################### ${Neutral} \n"
sleep 3

ExistInstall 'asterisk'

# Effacer les traces
trap Finish EXIT
