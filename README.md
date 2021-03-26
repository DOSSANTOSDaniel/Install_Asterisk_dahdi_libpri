# Script d'installation d'Asterisk, DAHDI et Libpri

USAGE:  ./GetAsterisk.sh -option [arg]

DESCRIPTION:
- Script permettant d'installer Asterisk et ses modules.
- Permet aussi de configurer automatiquement les comptes SIP.

| OPTIONS | ARGUMENTS | DESCRIPTION                                                        |   
| ---     | ---       | ---                                                                |
| -i      | full      | Installation d'Asterisk et modules Dahdi, Libpri.                  |
|         | dahdi     | Installation d'Asterisk et du module Dahdi.                        |
|         | ast       | Installation d'Asterisk.                                           |
|         | nfull     | Installation d'Asterisk et modules Dahdi, Libpri sans comptes SIP. |
|         | ndahdi    | Installation d'Asterisk et du module Dahdi sans comptes SIP.       |
|         | nast      | Installation d'Asterisk sans comptes SIP.                          |
| -h      |           | Affiche l'aide.                                                    |
| -v      |           | Affiche la version.                                                |

### A faire
- Permettre à l'utilisateur de choisir l'extension qu'il veut pour son compte SIP.
- Utiliser une base de données.
- Permettre à l'utilisateur de passer au script une liste des comptes SIP dans un fichier.
- Permettre à l'utilisateur de choisir un contexte.
- Limitation des comptes SIP à 999.
