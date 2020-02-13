#!/bin/bash

# Quand il y un exit, on efface les ressources que nous avons utilisées 
function Finish {
  for ErrExit in 'tar.gz.asc' 'sha256' 'tar.gz'
  do
    rm -rf "/usr/local/src/${VerAst}.${ErrExit}"
  done
}


# Effacer les traces
trap Finish EXIT
