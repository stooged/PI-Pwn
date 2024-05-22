#!/bin/bash

readarray -t devarr  < <(sudo blkid | grep '/dev/sd' | cut -f1 -d':')
for dev in "${devarr[@]}"; do
UDEV=${dev//"/dev/"}
if [ $1 == $UDEV ] ; then
if [ ! -d /media/pwndrives/$UDEV ]; then
mkdir /media/pwndrives/$UDEV
fi
sudo systemd-mount "${dev}" /media/pwndrives/$UDEV &
echo "sleep 5 ;sudo bash /boot/firmware/PPPwn/remount.sh "$UDEV | sudo at now
fi
done