#!/bin/bash

if [ -f /boot/firmware/PPPwn/upd.log ]; then
   sudo rm -f /boot/firmware/PPPwn/upd.log
fi
while read -r stdo ; 
do 
  echo -e $stdo | sudo tee /dev/tty1 | sudo tee /dev/pts/* | sudo tee -a /boot/firmware/PPPwn/upd.log
done < <(sudo bash /boot/firmware/PPPwn/update.sh)