#!/bin/bash
declare -a tab

tab[0]='daniel,1000,amour'
tab[1]='toto,1001,pass'

cat <<General
; Configuration des utilisateurs
[general]
userbase = 1000
hassip = yes
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
General > /etc/asterisk/users.conf

cat <<Voice
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
Voice > /etc/asterisk/voicemail.conf

cat <<Ext
[general]
static = yes
writeprotect = yes
clearglobalvars = yes
userscontext = users

[users]
Ext > /etc/asterisk/extensions.conf*

# nombres d'items dans le tableau
declare -i NbItem=$(echo "${#tab[*]}")
if [ ${NbItem} <= 9 ]
then
  NumExten='_100X'
elif [ ${NbItem} > 9 && ${NbItem} <= 99 ]
then
  NumExten='_10XX'
elif [ ${NbItem} > 99 && ${NbItem} <= 999 ]
then
  NumExten='_1XXX'
else
  echo "erreur extension"
fi

for i in "$tab[@]"
do
  local Nom="$(echo $tab[${i}] | awk -F, '{print $1}')"
  local Exten="$(echo $tab[${i}] | awk -F, '{print $2}')"
  local Passwd="$(echo $tab[${i}] | awk -F, '{print $3}')"

cat<<Users

[${Exten}](temp)
fullname = ${Nom}
username = ${Nom}
secret = ${Passwd}
cid_number = ${Exten}
  
Users >> /etc/asterisk/users.conf

cat<<Mail
${Exten} => ${Passwd}, ${Nom}
Mail >> /etc/asterisk/voicemail.conf

echo '
exten => NumExten,1,DIAL(SIP/${EXTEN},20)
exten => NumExten,2,Voicemail(${EXTEN}@users)
; Boîte vocale
exten => 666,1,Answer()
exten => 666,2, VoiceMailMain(${CALLERID(num)}@travail)
; Test echo
exten => 111, 1, answer
exten => 111, 2, Playback(demo-echotest)
exten => 111, 3, Echo()' >> /etc/asterisk/extensions.conf

sed -i -e 's/NumExten/${NumExten}/g' /etc/asterisk/extensions.conf 

done
