#!/bin/bash

readarray -t devarr  < <(sudo blkid | grep '^/dev/sd' | cut -f1 -d':')
for dev in "${devarr[@]}"; do
UDEV=${dev//"/dev/"}
if [ $1 == $UDEV ] ; then
if [ -d /media/pwndrives/$UDEV ]; then
sudo systemd-mount "${dev}" /media/pwndrives/$UDEV &
else
mkdir /media/pwndrives/$UDEV
sudo systemd-mount "${dev}" /media/pwndrives/$UDEV &
fi
fi
done