#!/bin/bash
clear
# 1.	Remove previously installed xrdp:
sudo systemctl disable xrdp
sudo systemctl stop xrdp
sudo apt purge xrdp -y
sudo apt purge xserver-xorg-core -y
sudo apt purge xserver-xorg-input-all -y
sudo apt purge xorgxrdp -y

#2. Re-install xrdp & required packages:
sudo apt install xrdp -y
sudo apt install xserver-xorg-core -y
sudo apt install xserver-xorg-input-all -y
sudo apt install xorgxrdp -y

#You also need to grant access to the /etc/ssl/private/ssl-cert-snakeoil.key file for xrdp user. It is available to members of the ssl-cert group by default.
sudo adduser xrdp ssl-cert 
sudo adduser pod ssl-cert 
# add xrdp into ssl-cert group

systemctl is-active xrdp 
# check xrdp state

# active
sudo systemctl enable xrdp 
sudo systemctl enable xrdp-sesman

# start xrdp on system start
sudo systemctl start xrdp-sesman
sudo systemctl start xrdp 
# start xrdp service

#3. Firewall configuration:   
sudo ufw allow 3389
# sudo ufw allow from 192.168.100.0/24 to any port 3389   # (dải ipv4 cho guacamole tới con VM cần điều khiển) 

#4. Reboot system OS:
#sudo reboot
