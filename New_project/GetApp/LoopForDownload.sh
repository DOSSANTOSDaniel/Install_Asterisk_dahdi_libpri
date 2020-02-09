#!/bin/bash

### Variables ###

#Déclaration des variables de couleur
declare -r Green='\e[1;32m'
declare -r Neutral='\e[0;m'
declare -r Red='\e[0;31m'
#Récupération IP
declare -r ip_check="$(hostname -i | awk '{print $1}')"

declare -r VerAsterisk='asterisk-16.7.0'
declare -r VerLibpri='libpri-1.6.0'
declare -r VerDahdi='dahdi-linux-complete-3.1.0+3.1.0'

declare -r KeyGpgAsterisk='0x5D984BE337191CE7'
declare -r KeyGpgDahdi='0x'
declare -r KeyGpgLibpri='0x'

#Téléchargements
declare -r DownloadDahdi='https://downloads.asterisk.org/pub/telephony/dahdi-linux-complete/releases'
declare -r DownloadLibpri='https://downloads.asterisk.org/pub/telephony/libpri/releases'
declare -r DownloadAsterisk='http://downloads.asterisk.org/pub/telephony/asterisk/releases'

### Fonctions ###
function FailMes {
  echo -e "\n ${Red} ### ${1} ### ${Neutral} \n"
}

function InfoMes {
  echo -e "\n ${Green} ### ${1} ### ${Neutral} \n"
}

function DownloadFile {
for Tools in "${VerAsterisk}" "${VerLibpri}"
do
  for Ext in 'tar.gz.asc' 'sha256' 'tar.gz'
  do
    wget -c -t 3 --progress=bar -O "/usr/local/src/${Tools}.${Ext}" "${DownloadAsterisk}/${Tools}.${Ext}" && sleep 1
  done
done
}

DownloadFile