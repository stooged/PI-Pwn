#!/bin/bash
#A simple way to upgrade pppwn version without c/p the entire bash code. Simply give run permissions and execute it into your embedded system.
sudo apt update
sudo apt install git -y
sudo rm -f -r PI-Pwn
sudo systemctl stop pipwn
git clone https://github.com/stooged/PI-Pwn
sudo mkdir /boot/firmware/
cd PI-Pwn
sudo cp -r PPPwn /boot/firmware/
cd /boot/firmware/PPPwn
sudo chmod 777 *
sudo bash install.sh
