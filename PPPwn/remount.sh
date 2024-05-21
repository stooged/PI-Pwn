#!/bin/bash

if [ -f /boot/firmware/PPPwn/config.sh ]; then
source /boot/firmware/PPPwn/config.sh
fi
if [ -z $VMUSB ]; then VMUSB=false; fi
if [ $VMUSB = true ] ; then
if [ -z $1 ]; then
  sudo rmmod g_mass_storage
  FOUND=0
  readarray -t rdirarr  < <(sudo ls /media/pwndrives)
  for rdir in "${rdirarr[@]}"; do
    readarray -t pdirarr  < <(sudo ls /media/pwndrives/${rdir})
    for pdir in "${pdirarr[@]}"; do
       if [[ ${pdir,,}  == "payloads" ]] ; then 
	     FOUND=1
	     UDEV='/dev/'${rdir}
	     break
      fi
    done
      if [ "$FOUND" -ne 0 ]; then
        break
      fi
  done  
  if [[ ! -z $UDEV ]] ;then
    echo $UDEV | sudo tee /boot/firmware/PPPwn/vdev.txt
    sudo modprobe g_mass_storage file=$UDEV stall=0 ro=0 removable=1
	echo -e "\033[92mUSB Drive:\033[93m Remounted\033[0m" | sudo tee /dev/tty1
  fi
else
  readarray -t pdirarr  < <(sudo ls /media/pwndrives/$1)
  for pdir in "${pdirarr[@]}"; do
     if [[ ${pdir,,}  == "payloads" ]] ; then 
       UDEV='/dev/'$1
       break
    fi
  done
  if [[ ! -z $UDEV ]] ;then
    sudo rmmod g_mass_storage
	echo $UDEV | sudo tee /boot/firmware/PPPwn/vdev.txt
    sudo modprobe g_mass_storage file=$UDEV stall=0 ro=0 removable=1
  fi
fi
fi