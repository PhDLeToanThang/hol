#!/bin/bash
clear
sudo apt update -y
sudo apt list --upgradable
sudo apt autoremove -y
sudo apt upgrade -y

# Cấu hình Remote Desktop Access RDP 3389 tới máy chủ vật lý hoặc máy ảo Ubuntu 20.x/22.x LTS server
# https://thangletoan.wordpress.com/2023/10/31/cau-hinh-remote-desktop-access-rdp-3389-toi-may-chu-vat-ly-hoac-may-ao-ubuntu-20-x-22-x-lts-server/
sudo apt install xrdp -y
sudo systemctl enable xrdp
sudo apt install ufw -y
sudo apt install net-tools -y
sudo apt install gparted -y
# hỏi AI: Tôi muốn cài remmina qua snap của ubuntu như lại chọn kiểu silent thì dùng lệnh cli ntn ?
sudo snap install remmina --classic

# Cách cấu hình điều khiển HĐH Linux qua Web HTML 5
# https://thangletoan.wordpress.com/2022/05/22/cach-cau-hinh-dieu-khien-hdh-linux-qua-web-html-5/
. /etc/os-release
sudo apt install -t ${VERSION_CODENAME}-backports cockpit -y

# After you already have Cockpit on your server, point your web browser to: https://ip-address-of-machine:9090

sudo apt install ubuntu-desktop -y
