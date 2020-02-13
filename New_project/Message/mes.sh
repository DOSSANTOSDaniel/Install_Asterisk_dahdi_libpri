#!/bin/bash

message() {
whiptail --title "$1" --msgbox "$2" 10 60
  # placer les logs ici
}

message "Erreur" "ecran cassé!"


