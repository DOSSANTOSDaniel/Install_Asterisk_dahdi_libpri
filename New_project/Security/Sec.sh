#!/bin/bash

apt install ufw -y
ufw enable
ufw status

ufw allow proto tcp from any to any port 5060,5061
