#!/bin/bash
declare -a tab

tab[0]='daniel,1000,amour'
tab[1]='toto,1001,pass'

cat <<General
; Configuration des utilisateurs
[general]
userbase = 6000
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
dtmfmode = rfc2833
disallow = all
allow = ulaw
allow = alaw
context = travail
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
userscontext = travail
saycid = yes
sendvoicemail = yes

[travail]
Voice > /etc/asterisk/voicemail.conf

cat <<Ext
[general]
static = yes
writeprotect = yes
clearglobalvars = yes
userscontext = travail

[travail]
Ext > /etc/asterisk/extensions.conf

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

cat <<Ex
exten =&gt; _600X,1,DIAL(SIP/${EXTEN},20)
exten =&gt; _600X,2,Voicemail(${EXTEN}@travail)
; Boîte vocale
exten =&gt; 666,1,Answer()
exten =&gt; 666,2, VoiceMailMain(${CALLERID(num)}@travail)
; Test echo
exten =&gt; 111, 1, answer
exten =&gt; 111, 2, Playback(demo-echotest)
exten =&gt; 111, 3, Echo()
Ex >> /etc/asterisk/extensions.conf
done
