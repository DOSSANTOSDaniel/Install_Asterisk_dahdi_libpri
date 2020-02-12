#!/bin/bash

User=$(w | awk '{print $1}' | awk 'NR==3')

apt get install sudo -y
usermod -aG sudo "$User"

apt install ufw -y
ufw status
ufw enable
ufw status
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh/tcp
ufw allow proto tcp from any to any port 5060,5061
ufw status verbose

apt install fail2ban -y
echo "
# ne pas éditer /etc/fail2ban/jail.conf
[DEFAULT]
destemail = root@gmail.com
sender = root@example.lan
ignoreip = 127.0.0.1/8 $ipnet $ipwifi
[sshd]
enabled = true
port = 22
maxretry = 10
findtime = 120
bantime = 1200
logpath = /var/log/auth.log
[sshd-ddos]
enabled = true
[recidive]
enabled = true
" > /etc/fail2ban/jail.d/defaults-debian.conf
sleep 1
systemctl restart fail2ban

apt install molly-guard -y
apt install rkhunter -y

