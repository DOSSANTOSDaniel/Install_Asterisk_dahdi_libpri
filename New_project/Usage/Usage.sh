#!/bin/bash

declare -r prog="$0"
usage() {
    cat <<USAGE
	Usage: ${prog} -[optionX]
	Option 1:   -f --full	Installation de Dahdi et Libpri.
	Option 2:   -d --dahdi	Installation de Dahdi.
	Option 4:   -n --noint  Installation d'asterisk non intéractive.
	Option 3:   -h --help   Aide

	Exemple 1:  ${prog}  -f		Installation des modules Dahdi et Libpri.	
	Exemple 2:  ${prog}  -d		Installation du module Dahdi seule.
	Exemple 2:  ${prog}  -h		Affiche l'aide.
	Exemple 2:  ${prog}		Installation d'Asterisk sans les modules Dahdi et Libpri.
USAGE
}
usage
