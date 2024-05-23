#!/bin/bash

if [ -f /boot/firmware/PPPwn/upd.log ]; then
   sudo rm -f /boot/firmware/PPPwn/upd.log
fi
echo "Checking for update..." | sudo tee /dev/tty1 | sudo tee /dev/pts/* | sudo tee -a /boot/firmware/PPPwn/upd.log
sudo mkdir /home/www-data
cd /home/www-data
sudo rm -f -r PI-Pwn
echo "Downloading files... " | sudo tee /dev/tty1 | sudo tee /dev/pts/* | sudo tee -a /boot/firmware/PPPwn/upd.log
git clone https://github.com/stooged/PI-Pwn
currentver=$(</boot/firmware/PPPwn/ver)
newver=$(<PI-Pwn/PPPwn/ver)
if [ $newver -gt $currentver ]; then
cd PI-Pwn
echo "Starting update..." | sudo tee /dev/tty1 | sudo tee /dev/pts/* | sudo tee -a /boot/firmware/PPPwn/upd.log
sudo systemctl stop pipwn
echo "Installing files... " | sudo tee /dev/tty1 | sudo tee /dev/pts/* | sudo tee -a /boot/firmware/PPPwn/upd.log
sudo cp -r PPPwn /boot/firmware/
cd /boot/firmware/PPPwn
sudo chmod 777 *
sudo bash install.sh update
else
sudo rm -f -r PI-Pwn
echo "No update found." | sudo tee /dev/tty1 | sudo tee /dev/pts/* | sudo tee -a /boot/firmware/PPPwn/upd.log
fi