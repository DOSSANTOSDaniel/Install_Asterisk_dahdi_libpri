#!/bin/bash

#===============================================================================
#          FILE:  GetAsterisk.sh
#         USAGE:  ./GetAsterisk.sh -option [arg]
#
#   DESCRIPTION:  Script permettant d'installer Asterisk et ses modules.
#		  Permet aussi de configurer automatique des comptes SIP.
#
#       OPTIONS:  -i full     Installation d'Asterisk et les modules Dahdi et Libpri.
#                 -i dahdi    Installation d'Asterisk et du module Dahdi.
#                 -i ast      Installation d'Asterisk.
#                 -i nfull    Installation d'Asterisk et les modules Dahdi et Libpri sans comptes SIP.
#                 -i ndahdi   Installation d'Asterisk et du module Dahdi sans comptes SIP.
#                 -i nast     Installation d'Asterisk sans comptes SIP.
#                 -h          Affiche l'aide.
#                 -v          Affiche la version.
#
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  DOS SANTOS Daniel daniel.massy91@gmail.com
#       VERSION:  1.0
#       CREATED:  12/02/2020
#===============================================================================

set -e

### Déclaration de variables ###
# Variables
declare -r CountryCode="33"
IpNet="$(hostname -I)"
declare -r IpNet
declare -r Ver='1.0'
declare -r Prog="$0"
# Asterisk
declare -r VerAst='asterisk-16.7.0'
declare -r KeyGpgAst='0x5D984BE337191CE7'
# DAHDI
declare -r VerDahdi='dahdi-linux-complete-3.1.0+3.1.0'
# Libpri
declare -r VerLibpri='libpri-1.6.0'
# Couleurs
declare -r Green='\e[1;32m'
declare -r Neutral='\e[0;m'
declare -r Red='\e[0;31m'
# Téléchargements
declare -r DownloadDahdi="https://downloads.asterisk.org/pub/telephony/dahdi-linux-complete/releases"
declare -r DownloadLibpri="https://downloads.asterisk.org/pub/telephony/libpri/releases"
declare -r DownloadAsterisk="http://downloads.asterisk.org/pub/telephony/asterisk/releases"
# Création des comptes SIP
declare ini=0
declare -a tab


### Déclaration des fonctions ###
Usage() {
    cat <<USAGE
	Usage: ${Prog} -option [arg] 
	Option 1:   -i     Types d'installations.
	Option 2:   -v     Version.
	Option 3:   -h     Aide.
	
	  Argument 1: [full]  Installation d'Asterisk, Dahdi et Libpri.
	  Argument 2: [dahdi] Installation d'Asterisk et du module Dahdi.
	  Argument 3: [ast] Installation d'Asterisk seulement.

    La configuration des comptes SIP ne sera pas faite avec les arguments suivants!
	  Argument 4: [nfull] Installation d'Asterisk, Dahdi et Libpri.
	  Argument 5: [ndahdi]  Installation d'asterisk et du module Dahdi.
	  Argument 6: [nast]  Installation d'asterisk seulement.

	Exemples:
	${Prog}  -i full	
	${Prog}  -i dahdi
	${Prog}  -i ast
	${Prog}  -v
	${Prog}  -h		
USAGE
exit 1
}

Version() {
cat <<Ver
  
	Script: ${0} Version: [${Ver}]

Ver
exit 1
}

Interface() {
declare -i imi=0
declare -i choix=0
declare -a tab
declare -i Exten=1000

while [ : ]
do
  if (whiptail --title "Boite de dialogue Oui / Non" --yesno "Voulez-vous ajouter des utilisateurs ?" 10 60)
  then
    Name=$(whiptail --title "Creation des comptes SIP" --inputbox "Entrer le nom utilisateur" 10 60 Daniel 3>&1 1>&2 2>&3)
    if [ "${?}" == "0" ]
    then
        choix="${choix}+1"
    else
        whiptail --title "Creation des comptes SIP" --msgbox "Vous avez annulez" 10 60
        unset "${tab[$imi]}"
        continue
    fi
    Password=$(whiptail --title "Creation des comptes SIP" --passwordbox "Entrer le mot de passe utilisateur" 10 60 password 3>&1 1>&2 2>&3)
    if [ "${?}" == "0" ]
    then
        choix="${choix}+1"
    else
        whiptail --title "Creation des comptes SIP" --msgbox "Vous avez annulez" 10 60
        unset "${tab["$imi"]}"
        continue
    fi    
    if (whiptail --title "Creation des comptes SIP" --yesno "Verification: Nom:$Name / Extetion:$Exten / Password:$Password" 20 70 3>&1 1>&2 2>&3)
    then
      if(whiptail --title "Creation des comptes SIP" --yesno "Sauvegarder l'utilisateur: ${Name} ?" 10 60)
      then
        whiptail --title "Compte SIP" --msgbox "Extension pour l'utilisateur ${Name} : ${Exten}" 10 60
        tab["${imi}"]="${Name},${Exten},${Password}"
        Exten=${Exten}+1
        imi="$imi+1"
      else
	continue
      fi        
    else
      whiptail --title "Creation des comptes SIP" --msgbox "Ajout des comptes terminé, Demarrage de l'installation!" 10 60
      break
      unset "${tab[${imi}]}"
    fi
  else
    whiptail --title "Asterisl Install" --msgbox "Demarrage de l'installation!" 10 60
    break
  fi
done
}

# Fonction permettant d'afficher un message
FailMes() {
  echo -e "\n ${Red} ### ${1} ### ${Neutral} \n"
  logger -t "${0}" "${1}"
}

InfoMes() {
  echo -e "\n ${Green} ### ${1} ### ${Neutral} \n"
  logger -t "${0}" "${1}"
}

# Quand il y un exit, on efface les ressources que nous avons utilisées 
Finish() {
# Efface les traces de l'installation d'Asterisk
  for Err in 'tar.gz.asc' 'sha256' 'tar.gz'
  do
    rm -rf "/usr/local/src/${VerAst}.${Err}"
  done
  cd /usr/local/src/${VerAst}
  if make uninstall
  then
    make uninstall-all
  else
    rm -rf /usr/local/src/${VerAst}
  fi
  
# Efface les traces de l'installation de DAHDI 
  for Err in 'sha1' 'tar.gz'
  do
    rm -rf "/usr/local/src/${VerDahdi}.${Err}"
  done
  cd /usr/local/src/${VerDahdi}
  if make uninstall
  then
    MesInfo 'Dahdi désinstalé!'
  else
    find / | grep dahdi > results
    xargs rm -R < results
  fi
  rm -rf /usr/local/src/${VerDahdi}
  
# Efface les traces de l'installation de Libpri 
  for Err in 'sha256' 'tar.gz'
  do
    rm -rf "/usr/local/src/${VerLibpri}.${Err}"
  done
  cd /usr/local/src/${VerLibpri}
  if make uninstall
  then
    MesInfo 'Libpri désinstalé!'
  else
    find / | grep libpri > results
    xargs rm -R < results
  fi
  rm -rf /usr/local/src/${VerLibpri}
  
  # Désinstallation d'applications
  apt remove whiptail -y
  apt remove dialog -y
}

ExistInstall() {
	Inx=$(dpkg -s "${1}" &> /dev/null | grep Status | awk '{print $2}')

	if [ "${Inx}" == "install" ]
	then
		FailMes "Attention ${1} est déjà installé"
    exit 9
	else 
    if [[ $(type -a "${1}" &> /dev/null) == "0" ]]
	  then
		  FailMes "Attention ${1} est déjà installé"
      exit 9
	  else
      if [[ $(test -d "/usr/local/src/${VerAst}") == "0" ]]
	    then
		    FailMes "Attention ${1} est déjà présent sur /usr/local/src/${VerAst}"
        exit 9
	    else
        echo ""
      fi
    fi    
	fi
}

InstallAst() {
  cd /usr/local/src/

  for FileEx in 'tar.gz.asc' 'sha256' 'tar.gz'
  do
    if [[ $(wget -c -t 3 --progress=bar -O "/usr/local/src/${VerAst}.${FileEx}" "${DownloadAsterisk}/${VerAst}.${FileEx}" && sleep 1) == "0" ]]
    then
        InfoMes "Le téléchargement du fichier ${VerAst}.${FileEx} est terminé !"
    else
        FailMes "Erreur de téléchargement du fichier ${VerAst}.${FileEx} !"
        exit 0
    fi
  done

  InfoMes "Test sha256sum :"
  cd /usr/local/src/
  
  if [[ $(sha256sum -c "/usr/local/src/${VerAst}.sha256") == "0" ]]
  then
    InfoMes "vérification de la somme de contrôle SHA256 OK !"
  else
    FailMes "Erreur sur la vérification de la somme de contrôle SHA256 du fichier ${VerAst}.tar.gz !"
    exit 1
  fi
  InfoMes "Test GPG :"
  gpg2 --keyserver 'hkp://keyserver.ubuntu.com' --recv-keys "${KeyGpgAst}"
  if [[ $(gpg2 --verify "/usr/local/src/${VerAst}.tar.gz.asc" "/usr/local/src/${VerAst}.tar.gz") == "0" ]]
  then
    InfoMes "vérification de la clé GPG OK !"
  else
    FailMes "Erreur de vérification de la clé GPG du fichier ${VerAst}.tar.gz !"
    exit 2
  fi

  if [[ $(tar xzvf "/usr/local/src/${VerAst}.tar.gz") == "0" ]]
  then
    InfoMes "Décompression OK !"
  else
    FailMes "Erreur de décompression du fichier ${VerAst}.tar.gz !"
    exit 3
  fi

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

  #Créer une sauvegarde des fichiers de configurations
  cp /etc/asterisk/sip.conf /etc/asterisk/sip.conf.back
  cp /etc/asterisk/users.conf /etc/asterisk/users.conf.back
  cp /etc/asterisk/extensions.conf /etc/asterisk/extensions.conf.back
  cp /etc/asterisk/voicemail.conf /etc/asterisk/voicemail.conf.back 

  sed -i -e 's/^#AST_USER="asterisk"/AST_USER="asterisk"/g' /etc/default/asterisk
  sed -i -e 's/^#AST_GROUP="asterisk"/AST_GROUP="asterisk"/g' /etc/default/asterisk

  sed -i -e 's/^;runuser = asterisk/runuser = asterisk/g' /etc/asterisk/asterisk.conf
  sed -i -e 's/^;rungroup = asterisk/rungroup = asterisk/g' /etc/asterisk/asterisk.conf

  sed -i -e 's/^;languageprefix = yes/languageprefix = yes/g' /etc/asterisk/asterisk.conf

  sed -i -e 's/^;defaultlanguage = en/defaultlanguage = fr/g' /etc/asterisk/asterisk.conf
  sed -i -e 's/^documentation_language = en_US/documentation_language = fr_FR/g' /etc/asterisk/asterisk.conf

  sed -i -e 's/^;language=en/language=fr/g' /etc/asterisk/sip.conf
  sed -i -e 's/^;tonezone=se/tonezone=fr/g' /etc/asterisk/sip.conf

  sed -i -e 's/^enabled = yes/enabled = no/g' /etc/asterisk/ari.conf

  /etc/init.d/asterisk start
  systemctl enable asterisk
  /etc/init.d/asterisk status
}

InstallDahdi() {
  apt-get install linux-headers-"$(uname -r)"
  for FileEx in 'tar.gz.sha1' 'tar.gz'
  do
    if [[ $(wget -c -t 3 --progress=bar -O "/usr/local/src/${VerDahdi}.${FileEx}" "${DownloadDahdi}/${VerDahdi}.${FileEx}" && sleep 1) == "0" ]]
    then
        InfoMes "Le téléchargement du fichier ${VerDahdi}.${FileEx} est terminé !"
    else
        FailMes "Erreur de téléchargement du fichier ${VerLibpri}.${FileEx} !"
        exit 0
    fi
  done

  InfoMes "Test sha1 :"
  cd /usr/local/src/
  if [[ $(sha1sum -c ${VerDahdi}.tar.gz.sha1) == "0" ]]
  then
    InfoMes "vérification de la somme de contrôle SHA1 OK !"
  else
    FailMes "Erreur sur la vérification de la somme de contrôle SHA1 du fichier ${VerDahdi}.tar.gz !"
    exit 1
  fi
  
  if [[ $(tar xzvf "/usr/local/src/${VerDahdi}.tar.gz") == "0" ]]
  then
    InfoMes "Décompression OK !"
  else
    FailMes "Erreur de décompression du fichier ${VerDahdi}.tar.gz !"
    exit 3
  fi

  cd /usr/local/src/dahdi-linux-complete-3.1.0+3.1.0/ 
  make
  make install
  make config

  lsmod | grep dahdi
  /etc/init.d/dadhi start
  /etc/init.d/asterisk status
}

InstallLibpri() {
  for FileEx in 'sha256' 'tar.gz'
  do
    if [[ $(wget -c -t 3 --progress=bar -O "/usr/local/src/${VerLibpri}.${FileEx}" "${DownloadLibpri}/${VerLibpri}.${FileEx}" && sleep 1) == "0" ]]
    then
        InfoMes "Le téléchargement du fichier ${VerLibpri}.${FileEx} est terminé !"
    else
        FailMes "Erreur de téléchargement du fichier ${VerLibpri}.${FileEx} !"
        exit 0
    fi
  done

  InfoMes "Test sha256 :"
  cd /usr/local/src/
  if [[ $(sha1sum -c ${VerLibpri}.sha256) == "0" ]]
  then
    InfoMes "vérification de la somme de contrôle SHA256 OK !"
  else
    FailMes "Erreur sur la vérification de la somme de contrôle SHA256 du fichier ${VerLibpri}.tar.gz !"
    exit 1
  fi
  
  if [[ $(tar xzvf "/usr/local/src/${VerLibpri}.tar.gz") == "0" ]]
  then
    InfoMes "Décompression OK !"
  else
    FailMes "Erreur de décompression du fichier ${VerLibpri}.tar.gz !"
    exit 3
  fi

  cd /usr/local/src/libpri-1.6.0
  make
  make install
}

UserSip() {
  echo '
; Configuration des utilisateurs
[general]
userbase = 1000
hassip = yes
hasvoicemail = yes
callwaiting = yes
threewaycalling = yes
callwaitingcallerid = yes
transfer = yes
canpark = yes
cancallforward = yes
callreturn = yes
callgroup = 1
pickupgroup = 1

[temp](!)
type = friend
host = dynamic
insecure=invite,port
canreinvite=yes
nat=yes
qualify=yes
dtmfmode = rfc2833
disallow = all
allow = ulaw
allow = alaw
context = users
' > /etc/asterisk/users.conf

echo '
; Configuration de la boîte de messagerie
[general]
format = wav49|gsm|wav
maxmsg = 100
maxsecs = 60
minsecs = 4
maxsilence = 2
maxlogins = 3
review = yes
userscontext = users
saycid = yes
sendvoicemail = yes

[users]
' > /etc/asterisk/voicemail.conf

echo '
[general]
static = yes
writeprotect = yes
clearglobalvars = yes
userscontext = users
' > /etc/asterisk/extensions.conf

# Nombres d'items dans le tableau
NbItem=$("${#tab[*]}")
declare -i NbItem
if (( NbItem <= 9 ))
then
  NumExten='_100X'
elif (( NbItem > 9 && NbItem <= 99 ))
then
  NumExten='_10XX'
elif (( NbItem > 99 && NbItem <= 999 ))
then
  NumExten='_1XXX'
else
  echo "erreur extension"
fi

echo '
[users]
exten => NumExten,1,DIAL(SIP/${EXTEN},20)
exten => NumExten,2,Voicemail(${EXTEN}@users)
; Boîte vocale
exten => 666,1,Answer()
exten => 666,2, VoiceMailMain(${CALLERID(num)}@users)
; Test echo
exten => 111, 1, answer
exten => 111, 2, Playback(demo-echotest)
exten => 111, 3, Echo()
' >> /etc/asterisk/extensions.conf
sed -i -e "s/^exten => NumExten/exten => ${NumExten}/g" /etc/asterisk/extensions.conf

for ini in "${tab[@]}"
do
  Nom=$(echo "$ini" | awk -F, '{print $1}')
  Passwd=$(echo "$ini" | awk -F, '{print $2}')
  ExtenSip=$(echo "$ini" | awk -F, '{print $3}')
  cat << EOF >> /etc/asterisk/users.conf
  [${ExtenSip}](temp)
  fullname = ${Nom}
  username = ${Nom}
  mailbox = ${ExtenSip}
  secret = ${Passwd}
  cid_number = ${ExtenSip} 

EOF
  cat << EOF >> /etc/asterisk/voicemail.conf
  ${ExtenSip} => ${Passwd}, ${Nom}
EOF
done
}

AppInstall() {
  # Installations d'applications
  apt update && apt full-upgrade -y
  apt install wget -y
  apt install gpg -y
  apt install vim -y
  apt install dialog -y
  apt install apt-utils -y
  apt install systemd -y
  apt install whiptail -y
  apt install sudo -y
  apt install ufw -y
  apt install fail2ban -y
  apt install molly-guard -y
  apt install rkhunter -y
}

### Code ###
ExistInstall 'asterisk'

# vérifier utilisateur
if [[ "$(id -u)" != "0" ]]
then 
  echo 'Attention ce script doit être démarré en root' 
  exit 1
fi 

# Récupération des options utilisateur
if [ $# -gt "2" ]
then
  echo "trop d'arguments !"
  exit 1
elif [[ $# -lt "1" ]]
then
  echo "Il faut une option et un argument"
  exit 1
elif [[ $1 =~ ^[^-.] ]]
then
  echo "$1 n'est pas une option! "
  exit 1
fi
 
while getopts ":i: :h :v" opt
do
  case $opt in
    i)
      case $OPTARG in
	      full)
		      echo "Installation d'Asterisk 16, Dadhi et Libpri"
          AppInstall
          Interface
          InstallAst
          InstallDahdi
          InstallLibpri
	        ;;
        dahdi)
		      echo "Installation d'Asterisk 16 et Dadhi"
          AppInstall
          Interface
          InstallAst
          InstallDahdi   
	        ;;
        ast)
		      echo "Installation d'Asterisk 16"
          AppInstall
          Interface
          InstallAst
          ;;
        nfull)
		      echo "Installation d'Asterisk 16, Dadhi et Libpri sans comptes Sip"
          AppInstall
          InstallAst
          InstallDahdi
          InstallLibpri          
	        ;;
        ndahdi)
		      echo "Installation d'Asterisk 16 et Dadhi sans comptes Sip"
          AppInstall
          InstallAst
          InstallDahdi          
	        ;;
        nast)
		      echo "Installation d'Asterisk 16 sans comptes Sip"
          AppInstall
          InstallAst                   
	        ;;
	      *)
		      echo "erreur d'arguments: $OPTARG"
		      exit 1
	        ;;
      esac 
      ;;
    h)
      Usage
      ;;
    v)
      Version
      ;;
    \?)
      echo "Cette option est invalide: $OPTARG" >&2
      exit 1
      ;;
    :)
      echo "L'option $OPTARG nécessite un argument." >&2
      exit 1
      ;;
  esac
done

### Sécurisation ###
# ajout de l'utilisateur loggé au groupe sudo
usermod -aG sudo "$(logname)"

# configuration de ufw 
ufw status
ufw enable
ufw status
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh/tcp
ufw allow proto tcp from any to any port 5060,5061
ufw status verbose

# Configuration de Fail2ban
echo "
# ne pas éditer /etc/fail2ban/jail.conf
[DEFAULT]
destemail = root@gmail.com
sender = root@example.lan
ignoreip = 127.0.0.1/8 $IpNet
[sshd]
enabled = true
port = 22
maxretry = 10
findtime = 120
bantime = 1200
logpath = /var/log/auth.log
[sshd-ddos]
enabled = true
[recidive]
enabled = true
" > /etc/fail2ban/jail.d/defaults-debian.conf
sleep 1
systemctl restart fail2ban

# Effacer les traces
trap Finish EXIT