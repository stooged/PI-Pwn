#!/bin/bash

readarray -t usbarr  < <(sudo ls /sys/bus/usb/drivers/usb)
for dev in "${usbarr[@]}"; do
if [[ $dev =~ ^[0-9] && ! "$dev" == *"."* ]]; then
echo $dev | sudo tee /sys/bus/usb/drivers/usb/unbind 
echo $dev | sudo tee /sys/bus/usb/drivers/usb/bind
fi
done