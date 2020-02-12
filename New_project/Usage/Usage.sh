#!/bin/bash

declare -r prog="$0"
usage() {
    cat <<USAGE
	Usage: ${prog} -[option]
	Option 1:   -f --full	Installation des modules Dahdi et Libpri.
	Option 2:   -d --dahdi	Installation du module Dahdi seule.
	Option 3:   -n --noint  Installation d'asterisk non intéractive.
	Option 4:   -h --help   Aide

	Exemple 1:  ${prog}  -f		Installation de Dahdi et Libpri.	
	Exemple 2:  ${prog}  -d		Installation de Dahdi.
	Exemple 3:  ${prog}		Installation d'Asterisk sans les modules Dahdi et Libpri.
	Exemple 4:  ${prog}  -n		Installation d'asterisk non intéractive.
	Exemple 5:  ${prog}  -h		Affiche l'aide.	
USAGE
}
usage
