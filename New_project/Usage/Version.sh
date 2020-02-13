#!/bin/bash

declare -r ver='1.0'

version() {
cat <<Ver
  
	Script: ${0} Version: [${ver}]

Ver
}

version
