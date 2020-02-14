#!/bin/bash

if (( $# > 2 ))
then
  echo "trop d'arguments !"
  exit 1
elif [[ $1 =~ ^[^-.] ]]
then
  echo "$1 n'est pas un option! "
fi
 
while getopts ":i: :h :v" opt
do
  case $opt in
    i)
      case $OPTARG in
	full)
		echo "Install tout"
	;;
        dahdi)
		echo "Install dahdi"
	;;
        noint)
		echo "Install non interact"
	;;
	*)
		echo "erreur d'arguments: $OPTARG"
		exit 1
	;;
      esac 
      ;;
    h)
      echo "-h aide aux commandes!" >&2
      ;;
    v)
      echo "-v version du script" >&2
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

