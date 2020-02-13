#!/bin/bash
set -e
declare -a tab
tab[0]='daniel,passewd,1000'
tab[1]='toto,pazzewd,1001'
tab[2]='ana,passw,1002'
tab[3]='todfdto,pazzewd,1003'
tab[4]='todto,pazzewd,1004'
tab[5]='todffto,pazzewd,1005'
tab[6]='totsso,pazzewd,1006'
tab[7]='todsto,pazzewd,1007'
tab[8]='totdfo,pazzewd,1008'
tab[9]='todfto,pazzewd,1009'
tab[10]='toddfto,pazzewd,1010'

declare ini=0

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

# nombres d'items dans le tableau
declare -i NbItem=$(echo "${#tab[*]}")
if (( ${NbItem} <= 9 ))
then
  NumExten='_100X'
elif (( ${NbItem} > 9 && ${NbItem} <= 99 ))
then
  NumExten='_10XX'
elif (( ${NbItem} > 99 && ${NbItem} <= 999 ))
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
Nom=$(echo $ini | awk -F, '{print $1}')
Passwd=$(echo $ini | awk -F, '{print $2}')
ExtenSip=$(echo $ini | awk -F, '{print $3}')
cat <<EOF >> /etc/asterisk/users.conf
[${ExtenSip}](temp)
fullname = ${Nom}
username = ${Nom}
secret = ${Passwd}
cid_number = ${ExtenSip} 

EOF
cat <<EOF >> /etc/asterisk/voicemail.conf
${ExtenSip} => ${Passwd}, ${Nom}
EOF
done
