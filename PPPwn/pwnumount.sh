#!/bin/bash

if [[ ! $1 == "" ]] ;then
sudo systemd-umount /media/pwndrives/$1 &
sleep 2
if [ -d /media/pwndrives/$1 ]; then
  sudo rm -r /media/pwndrives/$1
fi
fi