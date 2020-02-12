#!/bin/bash

declare -r prog="$0"
usage() {
    cat <<USAGE
	Usage: ${prog} -option [arg] 
	Option 1:   -i     Types d'installation.
	Option 2:   -h     Aide.
	
	Argument 1:	[full]		Installation de Dahdi et Libpri.
	Argument 2:	[dahdi]		Installation de Dahdi.
	
	Argument 3:	[noint]		Installation d'asterisk non intéractive.
					La configuration des utilisateurs ne sera pas demmandé.

	Exemple 1:  ${prog}  -i full	
	Exemple 2:  ${prog}  -i dahdi
	Exemple 3:  ${prog}  -i noint
	Exemple 4:  ${prog}		Installation d'Asterisk sans les modules Dahdi et Libpri.
	Exemple 5:  ${prog}  -h		
USAGE
}
usage
