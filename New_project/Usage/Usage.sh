#!/bin/bash

declare -r prog="$0"
usage() {
    cat <<USAGE
	Usage: ${prog} -option [arg] 
	Option 1:   -i     Types d'installation.
	Option 2:   -v     Version.
	Option 3:   -h     Aide.
	
	Argument 1:	[full]		Installation de Dahdi et Libpri.
	Argument 2:	[dahdi]		Installation de Dahdi.
	
	Argument 3:	[noint]		Installation d'asterisk non intéractive.
					La configuration des utilisateurs ne sera pas demmandé.

	Exemples:
	${prog}  -i full	
	${prog}  -i dahdi
	${prog}  -i noint
	${prog}			Installation d'Asterisk sans les modules Dahdi et Libpri.
	${prog}  -v
	${prog}  -h		
USAGE
}
usage
