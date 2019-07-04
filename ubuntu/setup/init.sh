#!/bin/bash

#: Apply some default settings for Ubuntu Desktop.  Configures OpenSSH and installs fail2ban.
#: Not 100% automatic, there may be prompts/dialogs.
#: 
#: Tested on Ubuntu Desktop 18.04.1
#: Author: Fastily

cd "${0%/*}" &> /dev/null

## Some global vars
res="../../shared" # resources folder

## Install some software
sudo apt update && \
sudo apt -y install curl fail2ban openssh-client openssh-server hfsprogs exfat-utils exfat-fuse screen net-tools

# Install Samba
bash ../installers/Samba.sh

## Apply custom settings for ssh
printf "Apply settings for ssh\n"
sudo mv "/etc/ssh/sshd_config" "/etc/ssh/sshd_config_BACKUP.txt" # create backup
sudo cp "${res}/sshd_config" "/etc/ssh/"

## create user ssh directories
mkdir -p ~/.ssh
touch ~/.ssh/authorized_keys

mkdir -p ~/bin

## Restart affected services
printf "Restarting affected services\n"
sudo service sshd restart
sudo service smbd restart


## Apply GUI Settings if possible
if hash gsettings 2>/dev/null; then
	gsettings set org.gnome.desktop.session idle-delay 0
	gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
	gsettings set org.gnome.desktop.media-handling autorun-never true
fi

printf "Done!\n"