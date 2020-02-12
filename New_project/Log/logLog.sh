#!/bin/bash
logger -t "${0}" 'Erreur'

# affichage des logs
cat /var/log/syslog | grep "${0}"
