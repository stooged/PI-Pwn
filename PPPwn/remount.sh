#!/bin/bash

if [ -f /boot/firmware/PPPwn/config.sh ]; then
source /boot/firmware/PPPwn/config.sh
fi
if [ -z $VMUSB ]; then VMUSB=false; fi

if [ $VMUSB = true ] ; then
  sudo rmmod g_mass_storage
  UDEV=$(sudo blkid | grep '^/dev/sd' | cut -f1 -d':')
  if [[ -z $UDEV ]] ;then
      UDEV="/media/PPPwn/pwndev"
	  echo -e "\033[92mVirtual Drive:\033[93m Remounted\033[0m" | sudo tee /dev/tty1
	else
	  echo -e "\033[92mFlash Drive:\033[93m Remounted\033[0m" | sudo tee /dev/tty1
  fi
   sudo modprobe g_mass_storage file=$UDEV stall=0 ro=0 removable=1
fi