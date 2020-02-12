#!/bin/bash

declare SipUsers

function Interface {

declare -i imi=0
declare -i choix=0
declare -i exitstatus=0
declare -a tab
declare -i Exten=1000

while [ : ]
do
  if (whiptail --title "Boite de dialogue Oui / Non" --yesno "Voulez-vous ajouter des utilisateurs ?" 10 60)
  then
    Name=$(whiptail --title "Creation des comptes SIP" --inputbox "Entrer le nom utilisateur" 10 60 Daniel 3>&1 1>&2 2>&3)
    exitstatus="${?}"
  
    if [ "${exitstatus}" = 0 ]
    then
        choix="${choix}+1"
    else
        whiptail --title "Creation des comptes SIP" --msgbox "Vous avez annulez" 10 60
        unset ${tab[$imi]}
        continue
    fi
    Password=$(whiptail --title "Creation des comptes SIP" --passwordbox "Entrer le mot de passe utilisateur" 10 60 password 3>&1 1>&2 2>&3)
    exitstatus="${?}"
    if [ "${exitstatus}" = 0 ]
    then
        choix="${choix}+1"
    else
        whiptail --title "Creation des comptes SIP" --msgbox "Vous avez annulez" 10 60
        unset ${tab["$imi"]}
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
      unset ${tab[${imi}]}
    fi
  else
    whiptail --title "Asterisl Install" --msgbox "Demarrage de l'installation!" 10 60
    break
  fi
done
SipUsers=$(echo "${tab[@]}")
}

Interface

echo "${SipUsers}"
