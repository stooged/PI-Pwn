#!/bin/bash

readarray -t usbarr  < <(sudo lsblk | grep "part" | sed "s^[^[:alnum:] /]^^g")
for dev in "${usbarr[@]}"; do
PARTITION=$(echo $dev | awk -F'part ' '{print $2}')
MOUNTPOINT=$(echo $dev | cut -f1 -d' ')
if [ -z $PARTITION ]; then
if [ ! -d /media/pwndrives ]; then
mkdir /media/pwndrives
fi
if [ ! -d /media/pwndrives/$MOUNTPOINT ]; then
mkdir /media/pwndrives/$MOUNTPOINT
fi
sudo mount "/dev/"$MOUNTPOINT /media/pwndrives/$MOUNTPOINT &
fi
done