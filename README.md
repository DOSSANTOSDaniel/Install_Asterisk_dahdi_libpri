# Script d'installation d'Asterisque, DAHDI et Libpri

* USAGE:  ./GetAsterisk.sh -option [arg]

* DESCRIPTION:
- Script permettant d'installer Asterisk et ses modules.
- Permet aussi de configurer automatiquement les comptes SIP.

| OPTIONS | ARGUMENTS | DESCRIPTION                                                             |   
| ---     | ---       | ---                                                                     |
| -i      | full      | Installation d'Asterisk et les modules Dahdi et Libpri.                 |
|         | dahdi     | Installation d'Asterisk et du module Dahdi.                             |
|         | ast       | Installation d'Asterisk.                                                |
|         | nfull     | Installation d'Asterisk et les modules Dahdi et Libpri sans comptes SIP.|
|         | ndahdi    | Installation d'Asterisk et du module Dahdi sans comptes SIP.            |
|         | nast      | Installation d'Asterisk sans comptes SIP.                               |
| -h      |           | Affiche l'aide.                                                         |
| -v      |           | Affiche la version.                                                     |