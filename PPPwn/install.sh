#!/bin/bash
sudo apt update
sudo apt install python3-scapy -y
sudo rm /usr/lib/systemd/system/bluetooth.target
sudo rm /usr/lib/systemd/system/network-online.target
sudo sed -i 's^"exit 0"^"exit"^g' /etc/rc.local
sudo sed -i 's^sudo bash /boot/firmware/PPPwn/run.sh \&^^g' /etc/rc.local
sudo sed -i 's^exit 0^sudo bash /boot/firmware/PPPwn/run.sh \&\n\nexit 0^g' /etc/rc.local
echo -e '\033[36mInstall complete,\033[33m Rebooting\033[0m'
sudo reboot
