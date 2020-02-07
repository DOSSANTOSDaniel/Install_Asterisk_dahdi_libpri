#!/bin/bash

# Lit une option et place cela dans la variable $option
while getopts ":d :l :f" option
do
  case ${option} in
    d ) echo "Install Dahdi";;
    l ) echo "Install Libpri";;
    f ) echo "Full Instal";;
    \? ) echo "Error use: [-d] or [-l] or [-f]";;
  esac
done